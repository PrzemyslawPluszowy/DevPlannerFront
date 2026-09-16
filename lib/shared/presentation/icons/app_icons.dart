import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Jedno miejsce mapowania ikon produktu.
///
/// Reszta aplikacji nie zależy bezpośrednio od biblioteki ikon. Dzięki temu
/// możemy zmienić zestaw wizualny bez przepisywania routingu i widgetów menu.
abstract final class AppIcons {
  const AppIcons._();

  static const IconData dashboard = Symbols.dashboard_rounded;
  static const IconData inventory = Symbols.inventory_2_rounded;
  static const IconData health = Symbols.health_and_safety_rounded;
  static const IconData workspaces = Symbols.dashboard_customize_rounded;
  static const IconData orders = Symbols.shopping_bag_rounded;
  static const IconData settings = Symbols.settings_rounded;
  static const IconData tasks = Symbols.checklist_rounded;
  static const IconData file = Symbols.description_rounded;
  static const IconData folder = Symbols.folder_rounded;
  static const IconData folders = Symbols.folder_copy_rounded;
  static const IconData wiki = Symbols.menu_book_rounded;
  static const IconData activity = Symbols.monitoring_rounded;
  static const IconData notifications = Symbols.notifications_rounded;
  static const IconData chat = Symbols.forum_rounded;
  static const IconData help = Symbols.help_rounded;
  static const IconData search = Symbols.search_rounded;
  static const IconData menu = Symbols.menu_rounded;
  static const IconData add = Symbols.add_rounded;
  static const IconData chevronRight = Symbols.chevron_right_rounded;
  static const IconData arrowLeft = Symbols.arrow_back_rounded;
  static const IconData privateSpace = Symbols.lock_rounded;
  static const IconData members = Symbols.group_rounded;
  static const IconData workflow = Symbols.account_tree_rounded;
  static const IconData pin = Symbols.push_pin_rounded;
  static const IconData kanban = Symbols.view_kanban_rounded;
  static const IconData whiteboard = Symbols.co_present_rounded;
  static const IconData automations = Symbols.smart_toy_rounded;
  static const IconData corkboard = Symbols.grid_view_rounded;
  static const IconData upload = Symbols.upload_rounded;
  static const IconData download = Symbols.download_rounded;
  static const IconData close = Symbols.close_rounded;
  static const IconData delete = Symbols.delete_rounded;
  static const IconData star = Symbols.star_rounded;
  static const IconData clock = Symbols.schedule_rounded;
  static const IconData users = Symbols.group_rounded;
  static const IconData sort = Symbols.swap_vert_rounded;
  static const IconData grid = Symbols.grid_view_rounded;
  static const IconData list = Symbols.format_list_bulleted_rounded;
  static const IconData refresh = Symbols.refresh_rounded;
  static const IconData checkCircle = Symbols.check_circle_rounded;
  static const IconData slash = Symbols.block_rounded;
  static const IconData lock = Symbols.lock_rounded;
  static const IconData alertCircle = Symbols.error_rounded;
  static const IconData image = Symbols.image_rounded;
  static const IconData document = Symbols.description_rounded;
  static const IconData video = Symbols.movie_rounded;
  static const IconData volume = Symbols.volume_up_rounded;
  static const IconData documentText = Symbols.article_rounded;
  static const IconData table = Symbols.table_chart_rounded;
  static const IconData presentation = Symbols.slideshow_rounded;
  static const IconData archive = Symbols.archive_rounded;
  static const IconData code = Symbols.code_rounded;
  static const IconData moreVertical = Symbols.more_vert_rounded;
  static const IconData chevronDown = Symbols.keyboard_arrow_down_rounded;
  static const IconData chevronUp = Symbols.keyboard_arrow_up_rounded;
  static const IconData share = Symbols.share_rounded;
  static const IconData link = Symbols.link_rounded;
  static const IconData user = Symbols.person_rounded;
  static const IconData print = Symbols.print_rounded;
  static const IconData saveCopy = Symbols.file_copy_rounded;
}

/// Material Symbols używane wyłącznie przez moduł Workspaces.
abstract final class WorkspaceIcons {
  const WorkspaceIcons._();

  static const IconData dashboard = Symbols.dashboard_rounded;
  static const IconData workspaces = Symbols.dashboard_customize_rounded;
  static const IconData settings = Symbols.settings_rounded;
  static const IconData tasks = Symbols.checklist_rounded;
  static const IconData file = Symbols.description_rounded;
  static const IconData folder = Symbols.folder_rounded;
  static const IconData folders = Symbols.folder_copy_rounded;
  static const IconData wiki = Symbols.menu_book_rounded;
  static const IconData activity = Symbols.monitoring_rounded;
  static const IconData notifications = Symbols.notifications_rounded;
  static const IconData chat = Symbols.forum_rounded;
  static const IconData menu = Symbols.menu_rounded;
  static const IconData add = Symbols.add_rounded;
  static const IconData chevronRight = Symbols.chevron_right_rounded;
  static const IconData arrowLeft = Symbols.arrow_back_rounded;
  static const IconData privateSpace = Symbols.lock_rounded;
  static const IconData members = Symbols.group_rounded;
  static const IconData workflow = Symbols.account_tree_rounded;
  static const IconData pin = Symbols.push_pin_rounded;
  static const IconData kanban = Symbols.view_kanban_rounded;
  static const IconData whiteboard = Symbols.co_present_rounded;
  static const IconData automations = Symbols.smart_toy_rounded;
  static const IconData corkboard = Symbols.grid_view_rounded;
  static const IconData upload = Symbols.upload_rounded;
  static const IconData download = Symbols.download_rounded;
  static const IconData close = Symbols.close_rounded;
  static const IconData delete = Symbols.delete_rounded;
  static const IconData star = Symbols.star_rounded;
  static const IconData clock = Symbols.schedule_rounded;
  static const IconData users = Symbols.group_rounded;
  static const IconData sort = Symbols.swap_vert_rounded;
  static const IconData grid = Symbols.grid_view_rounded;
  static const IconData list = Symbols.format_list_bulleted_rounded;
  static const IconData refresh = Symbols.refresh_rounded;
  static const IconData checkCircle = Symbols.check_circle_rounded;
  static const IconData slash = Symbols.block_rounded;
  static const IconData lock = Symbols.lock_rounded;
  static const IconData alertCircle = Symbols.error_rounded;
  static const IconData image = Symbols.image_rounded;
  static const IconData document = Symbols.description_rounded;
  static const IconData video = Symbols.movie_rounded;
  static const IconData volume = Symbols.volume_up_rounded;
  static const IconData documentText = Symbols.article_rounded;
  static const IconData table = Symbols.table_chart_rounded;
  static const IconData presentation = Symbols.slideshow_rounded;
  static const IconData archive = Symbols.archive_rounded;
  static const IconData code = Symbols.code_rounded;
  static const IconData moreVertical = Symbols.more_vert_rounded;
  static const IconData chevronDown = Symbols.keyboard_arrow_down_rounded;
  static const IconData chevronUp = Symbols.keyboard_arrow_up_rounded;
  static const IconData share = Symbols.share_rounded;
  static const IconData link = Symbols.link_rounded;
  static const IconData user = Symbols.person_rounded;
  static const IconData print = Symbols.print_rounded;
  static const IconData saveCopy = Symbols.file_copy_rounded;
}
