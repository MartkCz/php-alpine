<?php declare(strict_types = 1);

namespace App\Attribute;

use Attribute;

#[Attribute(Attribute::TARGET_PROPERTY)]
final class Key
{

	public function __construct(
		public string $key,
	)
	{
	}

}
