import 'dart:convert';

import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';

/// Buduje samodzielny host HTML dla podpisanej sesji OnlyOffice.
final class OnlyOfficeEditorHtmlBuilder {
  const OnlyOfficeEditorHtmlBuilder._();

  /// Waliduje odpowiedź backendu i osadza konfigurację z JWT w DocsAPI.
  static String build(OnlyOfficeSessionResponse session) {
    final serverUri = Uri.parse(session.documentServerUrl);
    if (!serverUri.hasScheme ||
        (serverUri.scheme != 'https' && serverUri.scheme != 'http')) {
      throw const FormatException('Nieprawidłowy adres serwera OnlyOffice.');
    }

    final tokenParts = session.token.split('.');
    if (tokenParts.length != 3) {
      throw const FormatException('Nieprawidłowy token sesji OnlyOffice.');
    }
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(tokenParts[1]))),
    );
    if (payload is! Map<String, dynamic> ||
        payload['document'] is! Map ||
        payload['editorConfig'] is! Map) {
      throw const FormatException('Token nie zawiera konfiguracji edytora.');
    }

    final configuration = Map<String, dynamic>.from(payload)
      ..remove('fileId')
      ..remove('docKey')
      ..['token'] = session.token;

    final editorConfig = Map<String, dynamic>.from(
      configuration['editorConfig'] as Map? ?? {},
    );
    editorConfig['lang'] ??= 'pl';
    editorConfig['region'] ??= 'pl-PL';
    configuration['editorConfig'] = editorConfig;

    final safeConfiguration = jsonEncode(configuration)
        .replaceAll('</', r'<\/');
    final apiUrl = serverUri
        .resolve('/web-apps/apps/api/documents/api.js')
        .toString();

    return '''<!doctype html>
<html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>OnlyOffice</title><style>html,body,#editor{height:100%;width:100%;margin:0;overflow:hidden}</style>
</head>
<body><div id="editor"></div><script>
const config=$safeConfiguration;
function send(type,data){
  if(window.storageBridge){window.storageBridge.postMessage(JSON.stringify({type:type,data:data}));}
}
function download(event){
  if(event&&event.data&&typeof event.data.url==='string'){
    send('download',{url:event.data.url,fileType:event.data.fileType});
  }
}
window.addEventListener('error',function(e){
  if(e&&e.message){send('runtimeError',e.message);}
},true);
window.addEventListener('unhandledrejection',function(e){
  if(e&&e.reason){send('runtimeError',String(e.reason));}
});
config.events=Object.assign({},config.events,{
  onAppReady:function(){send('appReady');},
  onUserActionRequired:function(){send('userActionRequired');},
  onDocumentReady:function(){send('ready');},
  onDocumentStateChange:function(event){send('modified',event&&event.data?'1':'0');},
  onError:function(event){send('error',event.data&&event.data.errorCode);},
  onWarning:function(event){send('warning',event.data&&event.data.warningCode);},
  onRequestClose:function(){send('close');},
  onDownloadAs:download
});
const apiScript=document.createElement('script');
apiScript.src="${_escapeAttribute(apiUrl)}";
apiScript.onload=function(){
  send('apiLoaded');
  try{
    if(!window.DocsAPI){send('error','api_unavailable');}
    else{
      window.storageEditor=new DocsAPI.DocEditor('editor',config);
      send('editorCreated',{
        hostOrigin:window.location.origin==='null'?'opaque':'web'
      });
    }
  }catch(error){send('runtimeError',String(error));}
};
apiScript.onerror=function(){send('apiLoadError');};
document.head.appendChild(apiScript);
</script></body></html>''';
  }

  static String _escapeAttribute(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('"', '&quot;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');
}
