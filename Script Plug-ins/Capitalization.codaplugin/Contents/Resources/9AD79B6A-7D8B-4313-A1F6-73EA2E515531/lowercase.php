#!/usr/bin/php
<?php

$fp = fopen('php://stdin', 'r');

while ( $line = fgets($fp, 4096) )
	echo mb_strtolower($line, "utf-8"); 

fclose($fp);

?>