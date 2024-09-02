<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;
use Rector\Set\ValueObject\DowngradeLevelSetList;
// use Rector\Configuration\Option;
// use Rector\ValueObject\PhpVersion;
// use Rector\Set\ValueObject\DowngradeSetList;
// use Rector\Set\ValueObject\DowngradeLevelSetList;

// return static function (RectorConfig $rectorConfig): void {
//   // // get parameters
//   // $parameters = $rectorConfig->parameters();
//   // $parameters->set(Option::PATHS, [
//   //   __DIR__ . '/dist/cm4all-wp-impex-php7.4.0'
//   // ]);
//   // $rectorConfig->paths([__DIR__ . '/dist/cm4all-wp-impex-php7.4.0']); #

//   $rectorConfig->skip([__DIR__ . '/vendor']);

//   // $parameters->set(Option::PARALLEL, false);
//   $rectorConfig->disableParallel();

//   // $parameters->set(Option::PHP_VERSION_FEATURES, PhpVersion::PHP_80);
//   $rectorConfig->phpVersion(PhpVersion::PHP_80);

//   // Define what rule sets will be applied
//   // $rectorConfig->import(DowngradeLevelSetList::DOWN_TO_PHP_80);
//   // $rectorConfig->import(DowngradeSetList::PHP_80);
//   $rectorConfig->sets(
//     [
//       DowngradeLevelSetList::DOWN_TO_PHP_80,
//       DowngradeSetList::PHP_80
//     ]
//   );
// };

return RectorConfig::configure()
  ->withSkip([__DIR__ . '/vendor'])
  ->withParallel()
  // see https://github.com/rectorphp/rector-src/blob/3ed476b9ab65958d85416e48a810b11dbaf4283a/build/config/config-downgrade.php
  //->withPHPStanConfigs([__DIR__ . '/phpstan-for-downgrade.neon'])
  ->withDowngradeSets(php74: true);
