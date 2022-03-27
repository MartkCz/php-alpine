<?php declare(strict_types = 1);

namespace App\Command;

use App\Command\Argument\PhpFpmArguments;
use Nette\Utils\FileSystem;
use Nette\Utils\Strings;
use WebChemistry\Console\BaseCommand;

final class PhpFpmCommand extends BaseCommand
{

	protected static $defaultName = 'php-fpm';

	protected PhpFpmArguments $arguments;

	protected function exec(): void
	{
		$content = FileSystem::read('../conf/php-fpm/www.prod.conf');

		if ($this->arguments->processors) {
			$this->replaceMany($content, [
				'pm' => 'dynamic',
				'pm.start_servers' => $this->arguments->processors * 4,
				'pm.max_spare_servers' => $this->arguments->processors * 4,
				'pm.min_spare_servers' => $this->arguments->processors * 2,
			]);
		}
	}

	public function replaceMany(string &$content, array $values): void
	{
		foreach ($values as $key => $value) {
			$this->replace($content, $key, $value);
		}
	}

	public function replace(string &$content, string $key, mixed $value): void
	{
		$content = Strings::replace(
			$content,
			sprintf('#^(%s\s*=).*$#m', preg_quote($key, '#')),
			'$1 ' . $value
		);
	}

}
