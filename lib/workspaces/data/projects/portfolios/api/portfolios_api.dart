import 'package:devplanner/workspaces/data/projects/portfolios/models/portfolio_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'portfolios_api.g.dart';

/// Klient Retrofit endpointów portfolio w Workspaces.
@RestApi()
abstract class PortfoliosApi {
  /// Tworzy klienta dla uwierzytelnionego Dio Workspaces.
  factory PortfoliosApi(Dio dio, {String? baseUrl}) = _PortfoliosApi;

  /// Pobiera portfolio workspace, opcjonalnie filtrując po nazwie.
  @GET('/api/v1/workspaces/{workspaceId}/portfolios/')
  Future<List<PortfolioResponse>> listPortfolios(
    @Path('workspaceId') String workspaceId, {
    @Query('query') String? query,
  });

  /// Tworzy portfolio w workspace.
  @POST('/api/v1/workspaces/{workspaceId}/portfolios/')
  Future<PortfolioResponse> createPortfolio(
    @Path('workspaceId') String workspaceId,
    @Body() CreatePortfolioPayload body,
  );

  /// Pobiera szczegóły portfolio wraz z przypisanymi projektami.
  @GET('/api/v1/workspaces/{workspaceId}/portfolios/{portfolioId}')
  Future<PortfolioResponse> getPortfolio(
    @Path('workspaceId') String workspaceId,
    @Path('portfolioId') String portfolioId,
  );

  /// Aktualizuje nazwę i opis portfolio.
  @PUT('/api/v1/workspaces/{workspaceId}/portfolios/{portfolioId}')
  Future<PortfolioResponse> updatePortfolio(
    @Path('workspaceId') String workspaceId,
    @Path('portfolioId') String portfolioId,
    @Body() UpdatePortfolioPayload body,
  );

  /// Trwale usuwa portfolio bez usuwania projektów.
  @DELETE('/api/v1/workspaces/{workspaceId}/portfolios/{portfolioId}')
  Future<void> deletePortfolio(
    @Path('workspaceId') String workspaceId,
    @Path('portfolioId') String portfolioId,
  );

  /// Przypisuje projekty do portfolio.
  @POST('/api/v1/workspaces/{workspaceId}/portfolios/{portfolioId}/projects')
  Future<PortfolioResponse> addPortfolioProjects(
    @Path('workspaceId') String workspaceId,
    @Path('portfolioId') String portfolioId,
    @Body() AddPortfolioProjectsPayload body,
  );

  /// Usuwa jeden projekt z portfolio, nie usuwając samego projektu.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/portfolios/{portfolioId}/projects/{projectId}',
  )
  Future<PortfolioResponse> removePortfolioProject(
    @Path('workspaceId') String workspaceId,
    @Path('portfolioId') String portfolioId,
    @Path('projectId') String projectId,
  );

  /// Pobiera zagregowane metryki portfolio.
  @GET('/api/v1/workspaces/{workspaceId}/portfolios/{portfolioId}/dashboard')
  Future<PortfolioDashboardResponse> getPortfolioDashboard(
    @Path('workspaceId') String workspaceId,
    @Path('portfolioId') String portfolioId,
  );
}
