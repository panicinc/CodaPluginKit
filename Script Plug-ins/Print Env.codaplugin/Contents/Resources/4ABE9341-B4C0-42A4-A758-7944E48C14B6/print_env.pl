#!/usr/bin/perl

print "<html>$CODA_LINE_ENDING";
print "<body>$CODA_LINE_ENDING";

print "<style type=\"text/css\"> table { width: 100% } td { padding: 6px; font-size: 12px;font-family: \"Lucida Grande\";} </style>";
print "<table>$CODA_LINE_ENDING";

$i = 0;

for my $key ( keys %ENV ) 
{
    my $value = $ENV{$key};

 	if ( ($i % 2) == 0 )
 	{
 		print "<tr bgcolor=#f1f5fa>$CODA_LINE_ENDING";
	}
	else
	{
		print "<tr bgcolor=#fafafa>$CODA_LINE_ENDING";
	}

	print "<td><b>$key</b></td>$CODA_LINE_ENDING"; 
    print "<td>$value</td>$CODA_LINE_ENDING";

    print "</tr>$CODA_LINE_ENDING";
    
    ++$i;
}

print "</table>$CODA_LINE_ENDING";
print "</font>";

print "</body>$CODA_LINE_ENDING";
print "</html>$CODA_LINE_ENDING";

