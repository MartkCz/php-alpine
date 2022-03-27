<?php declare(strict_types = 1);

namespace App;

use App\Command\PhpCommand;
use App\Command\PhpFpmCommand;

final class Application
{

	public static function boot(): void
	{
		$app = new \Symfony\Component\Console\Application('configurator', 'stable');
		$app->addCommands([
			new PhpCommand(),
			new PhpFpmCommand(),
		]);

		$app->run();
	}

}
