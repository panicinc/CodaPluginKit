#!/usr/bin/php
<?php

if(function_exists("date_default_timezone_set") and function_exists("date_default_timezone_get"))
	@date_default_timezone_set(@date_default_timezone_get());

print date("Y-m-d");

?>