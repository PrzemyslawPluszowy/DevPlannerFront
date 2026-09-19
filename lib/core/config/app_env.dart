/// Backwards-compatible import for the pre-6A `core` tree.
///
/// New composition-root code must import the canonical configuration from
/// `foundation/config/app_env.dart`. Keeping this forwarding library for one
/// migration slice lets dormant feature code compile without reintroducing
/// legacy service configuration.
library;
export 'package:devplanner/foundation/config/app_env.dart';
