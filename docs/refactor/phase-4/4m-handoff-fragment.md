### 4M — frontend final identity DTOs

Front domknął bezpośrednie identity DTO admin Ops i workspace feature:
`SystemErrorLogResponse.userId`, admin query `userId`, aktywność
`actorUserId` oraz global search Chat `authorUserId`. Odświeżono Freezed/JSON/
Retrofit outputs i dodano `identity_dto_userid_contract_test.dart`.

Dowody: generator 185 outputs PASS, focused suite 7/7 PASS,
`flutter analyze` PASS, `git diff --check` PASS, scoped legacy scan clean.
Backend musi dostarczyć identyczny transportowy kontrakt; Front nie posiada
aliasów, dual-read/write ani fallbacków Core/Ready.
