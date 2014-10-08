#!/usr/bin/php
<?php

$input = "";

$fp = fopen("php://stdin", "r");
while ( $line = fgets($fp, 1024) )
	$input .= $line;
	
fclose($fp);

$input = rtrim($input);
$input = preg_replace("/[\r\n]/", "", $input);
echo $input . "\n";

?>