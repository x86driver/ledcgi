#!/usr/bin/perl -w

  my ($data, $i, @data, $key, $val, %FORM);

  if ($ENV{'REQUEST_METHOD'} eq "GET") {
    $data = $ENV{'QUERY_STRING'};
  } elsif ($ENV{'REQUEST_METHOD'} eq "POST") {
    read(STDIN,$data,$ENV{'CONTENT_LENGTH'});
  }

  @data = split(/&/,$data);

  foreach $i (0 ..$#data) {
    # Convert plus's to spaces
    $data[$i] =~ s/\+/ /g;

    # Split into key and value.
    # splits on the first =
    ($key, $val) = split(/=/,$data[$i],2);

    # Convert %XX from hex numbers to alphanumeric
    $key =~ s/%(..)/pack("c",hex($1))/ge;
    $val =~ s/%(..)/pack("c",hex($1))/ge;

    # Kill SSI command
    $val =~ s/<!--(.|\n)*-->//g;

    # Associate key and value
    # \0 is the multiple separator
    $FORM{$key} .= "\0" if (defined($FORM{$key}));
    $FORM{$key} .= $val;

  }


print "Content-type: text/html\n\n";

print "<html>\n";
print "<head>\n";
print "<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">\n";
print "<title>CGI程式入門-範例1</title>\n";
print "</head>\n";
print "<body bgcolor=white>\n";

print "CGI程式所收到的資料串是長的這個樣子的：<p>\n";
print "$data<p>\n";
print "<hr>\n";

### Print variables
  print "FORM裡面的資料經過程式處理之後就變成這樣了：<p>\n";
  foreach $key (keys %FORM) {
    print "$key = $FORM{$key}<br>\n";
    if ($key == "power") {
	if ($FORM{$key} eq "on") {
	    print "因為 $FORM{$key} 我要執行 ./led 1<br>\n";
	    system("/home/shane/pro/led/led 1");
	} else {
	    print "因為 $FORM{$key} 我要執行 ./led 0<br>\n";
	    system("/home/shane/pro/led/led 0");
	}
    }
  }

print "<hr>\n";

### print %ENV
  print "環境變數列表：<p>\n";
  foreach $key (sort keys %ENV) {
    print "$key = $ENV{$key}<br>\n";
  }

print "</body>\n";
print "</html>\n";
