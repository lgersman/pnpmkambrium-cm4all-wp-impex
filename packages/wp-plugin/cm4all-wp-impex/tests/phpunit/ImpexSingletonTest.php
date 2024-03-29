<?php

namespace cm4all\wp\impex\tests\phpunit;

use cm4all\wp\impex\Impex;
use Error;

class ImpexSingletonTest extends ImpexUnitTestcase
{
  public function setUp(): void
  {
    // cleanup registered extensions before running test function
    $reset = function () {
      self::$instance = null;
    };

    // https://stackoverflow.com/questions/20334355/how-to-get-protected-property-of-object-in-php/44361579#44361579
    $reset->call(Impex::getInstance());
    Impex::getInstance();
  }

  function testSingletonInitialized(): void
  {
    $this->assertNotNull(Impex::getInstance()->Export);

    $this->assertNotNull(Impex::getInstance()->Import);
  }

  function testImpexIsSingleton(): void
  {
    $this->assertNotNull(Impex::getInstance());

    $this->assertInstanceOf(Impex::class, Impex::getInstance());

    $this->assertEquals(Impex::getInstance(), Impex::getInstance());

    $this->expectException(Error::class);
    $impex = new Impex();
  }
}
