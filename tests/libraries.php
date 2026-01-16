<?php declare(strict_types = 1);

ini_set('display_errors', '1');
error_reporting(-1);

$imageFormats = ['avif', 'gif', 'jpg', 'png', 'webp'];

// test iconv
$value = iconv('UTF-8', 'ASCII//IGNORE//TRANSLIT', 'foo');

assert($value === 'foo');

// test bcmath extension
assert(bcadd('1', '2') === '3');

// test ds extension
$set = new DS\Set();
$set->add('foo');

assert($set->contains('foo') === true);

// test brotli extension
$compressed = brotli_compress('foo');
$uncompressed = brotli_uncompress($compressed);

assert($uncompressed === 'foo');

// test exif extension
foreach ($imageFormats as $format) {
	$type = exif_imagetype(__DIR__ . "/assets/image.$format");

	if ($format === 'jpg') {
		assert($type === IMAGETYPE_JPEG);
	} elseif ($format === 'png') {
		assert($type === IMAGETYPE_PNG);
	} elseif ($format === 'gif') {
		assert($type === IMAGETYPE_GIF);
	} elseif ($format === 'webp') {
		assert($type === IMAGETYPE_WEBP);
	} elseif ($format === 'avif') {
		assert($type === IMAGETYPE_AVIF);
	} else {
		throw new Exception("Unsupported image format: $format");
	}
}

// test gmp
$sum = gmp_add("123456789012345", "76543210987655");

assert(gmp_strval($sum) === "200000000000000");

// test igbinary
$igbinary = igbinary_serialize(['foo' => 'bar']);
$unigbinary = igbinary_unserialize($igbinary);

assert($unigbinary === ['foo' => 'bar']);

// test intl
$formatter = new NumberFormatter('en_US', NumberFormatter::CURRENCY);
$formatted = $formatter->formatCurrency(1234.56, 'USD');

assert($formatted === '$1,234.56');

// test gd
foreach ($imageFormats as $format) {
	$image = imagecreatefromstring(file_get_contents(__DIR__ . "/assets/image.$format"));
	assert($image !== false);

	$width = imagesx($image);
	$height = imagesy($image);
	$newImage = imagecreatetruecolor($width / 2, $height / 2);

	imagecopyresampled($newImage, $image, 0, 0, 0, 0, $width / 2, $height / 2, $width, $height);

	if ($format === 'jpg') {
		imagejpeg($newImage, __DIR__ . "/assets/output.$format");
	} elseif ($format === 'png') {
		imagepng($newImage, __DIR__ . "/assets/output.$format");
	} elseif ($format === 'gif') {
		imagegif($newImage, __DIR__ . "/assets/output.$format");
	} elseif ($format === 'webp') {
		imagewebp($newImage, __DIR__ . "/assets/output.$format");
	} elseif ($format === 'avif') {
		imageavif($newImage, __DIR__ . "/assets/output.$format");
	} else {
		throw new Exception("Unsupported image format: $format");
	}

	$type = exif_imagetype(__DIR__ . "/assets/output.$format");

	if ($format === 'jpg') {
		assert($type === IMAGETYPE_JPEG);
	} elseif ($format === 'png') {
		assert($type === IMAGETYPE_PNG);
	} elseif ($format === 'gif') {
		assert($type === IMAGETYPE_GIF);
	} elseif ($format === 'webp') {
		assert($type === IMAGETYPE_WEBP);
	} elseif ($format === 'avif') {
		assert($type === IMAGETYPE_AVIF);
	} else {
		throw new Exception("Unsupported image format: $format");
	}
}

// test pcntl
$fn = static fn () => true;

assert(pcntl_signal(SIGTERM, $fn) === true);
assert(pcntl_signal_get_handler(SIGTERM) === $fn);

// test zlib
$compressed = gzcompress('foo');
$uncompressed = gzuncompress($compressed);
assert($uncompressed === 'foo');

// test extension_loaded
$extensions = [
	'iconv',
	'bcmath',
	'ds',
	'brotli',
	'exif',
	'gmp',
	'igbinary',
	'intl',
	'gd',
	'pcntl',
	'zlib',
];

foreach ($extensions as $extension) {
	assert(extension_loaded($extension) === true, "Extension $extension is not loaded");
}

// test opcache is enabled
assert(function_exists('opcache_get_status') === true);
$status = opcache_get_status();
assert(is_array($status), 'Opcache status is not an array');
assert($status['opcache_enabled'] === true, 'Opcache is not enabled');

// test uuid
//$uuid = uuid_create();
//assert(strlen($uuid) === 36);
//assert(count(explode('-', $uuid)) === 5);
//assert(strlen(uuid_parse($uuid)) === 16);
//assert($uuid === uuid_unparse(uuid_parse($uuid)));
