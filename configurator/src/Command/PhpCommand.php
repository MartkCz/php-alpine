<?php declare(strict_types = 1);

namespace App\Command;

use App\Attribute\Key;
use App\Command\Argument\PhpCommandArguments;
use Nette\Utils\FileSystem;
use Nette\Utils\Strings;
use ReflectionClass;
use WebChemistry\Console\BaseCommand;

final class PhpCommand extends BaseCommand
{

	protected static $defaultName = 'php';

	protected PhpCommandArguments $arguments;

	protected function exec(): void
	{
		$reflection = new ReflectionClass($this->arguments);

		$content = FileSystem::read('/prod/php/99_settings.ini');

		foreach ($reflection->getProperties() as $property) {
			$value = $property->getValue($this->arguments);

			if ($value === null) {
				continue;
			}

			foreach ($property->getAttributes(Key::class) as $attribute) {
				/** @var Key $instance */
				$instance = $attribute->newInstance();

				$content = Strings::replace(
					$content,
					sprintf('#^(%s\s*=).*$#m', preg_quote($instance->key, '#')),
					'$1 ' . $value
				);
			}
		}

		$suffix = getenv('PHP_SUFFIX');

		if (!is_string($suffix)) {
			$this->error('Env PHP_SUFFIX does not exist.');
		}

		FileSystem::write('/etc/php' . $suffix . '/conf.d/99_settings.ini', $content);
	}

}
