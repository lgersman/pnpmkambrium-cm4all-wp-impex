<?php

namespace cm4all\wp\impex\tests\phpunit;

use cm4all\wp\impex\ImpexPart;

/**
 * @TODO: move testExportExtractWithOptions to this class
 */
class ImpexPartTest extends ImpexUnitTestcase
{
  function testGetInstanceFails(): void
  {
    $this->expectException(\Error::class);
    ImpexPart::class::getInstance();
  }
}
