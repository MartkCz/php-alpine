<?php declare(strict_types = 1);

namespace App\Command\Argument;

use App\Attribute\Key;

final class PhpCommandArguments
{

	#[Key('memory_limit')]
	public ?string $memoryLimit;

	#[Key('max_execution_time')]
	public ?int $maxExecutionTime;

}
