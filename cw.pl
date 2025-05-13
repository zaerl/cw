#!/usr/bin/perl

# This is an old Perl 5.* script I keep the same without modernizing.
# See https://zaerl.com/2025/05/13/perl-my-old-friend/

&help unless(scalar @ARGV);

while(@ARGV) {
    &process_node(shift)
}

@temp1 = reverse sort by_popularity keys %popularity;
$count = $popularity{$temp1[0]};
print "$count: ";

foreach $key (@temp1) {
    if($popularity{$key} != $count) {
        $count = $popularity{$key};
        $onlyf = 0;
        print "\n$count: ";
    }

    if(++$onlyf == 10) {
        print "more...";
    } elsif($onlyf < 10) {
        print "$key ";
    }
}

@temp2 = reverse sort by_paragraph keys %paragraph;
print "\n\nLONGEST PARAGRAPHS\n\n";
$count = 0;

foreach $key (@temp2) {
    if($count++ < 10) {
        print "$key ", $paragraph{$key}{"occurrence"};
        print " ", $paragraph{$key}{"file"}, " ", $paragraph{$key}{"line"},
			"\n";
    } else {
        print "more...";
        last;
    }
}

sub by_popularity {
    return $popularity{$a} <=> $popularity{$b};
}

sub by_paragraph {
    return $a <=> $b;
}

sub process_node {
    local $temp_name = shift;
    local $line = 1;

    open(INPUTFILE, $temp_name) || warn "Could not open $temp_name\n";

    while(<INPUTFILE>) {
        $l = length($_);

        if($l > 1) {
            ++$paragraph{$l}{"occurrence"};
            $paragraph{$l}{"file"} = $temp_name;
            $paragraph{$l}{"line"} = $line;
        }

        foreach $val (split(/[\s\'\\\{\}\.\,\;\:\?\!\`\[\]]/)) {
            if(length $val) {
                ++$popularity{lc($val)};
            }
        }

        ++$line;
    }

    close INPUTFILE;
}

sub help {
    print "A little tool for counting words\n",
    	"USAGE: cw.pl file1 file2 ...\n";
    exit 0;
}
