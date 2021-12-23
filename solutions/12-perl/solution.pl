use strict;
use warnings;
use Class::Struct;
use Data::Dump qw(dump);

sub is_max_visited {
  my $tt = shift;

  foreach my $key (keys %{ $tt }) {
    return 1 if($tt->{$key} ge 2);
  }
}

my %connections; 

sub is_small {
  return 1 if($_[0] eq lc($_[0]) && $_[0] ne "end" && $_[0] ne "start");
  return;
}

sub part_one {
  my $connects    = shift;
  my $start       = shift;
  my $end         = shift;
  my $seen_nodes  = shift;
  my $indent      = shift;

  # dump $indent, "Connects: ", $connects;
  # dump $indent, "Seen: ", $seen_nodes;

  my $count = 0;

  for my $el (@{$connects}) {
    next if $el eq $start;
    if($el eq $end) {
      ++$count;
      next;
    }

    next if ($el ~~ $seen_nodes);

    if(is_small($el)) {
      # dump $indent, "checking", $el;
      my @next_seen_nodes = @{$seen_nodes};
      push @next_seen_nodes, $el;
      $count += part_one($connections{$el}, $start, $end, \@next_seen_nodes, $indent."  ");
    } else {
      # dump $indent, "checking", $el;
      $count += part_one($connections{$el}, $start, $end, $seen_nodes, $indent."  ");
    }
  }

  return $count;
}


sub part_two {
  my $connects       = shift;
  my $start          = shift;
  my $end            = shift;
  my $seen_node_map  = shift;
  my $indent         = shift;
  my $iterations     = shift;


  # dump $indent, "Connects: ", $connects;
  # dump $indent, "Seen: ", $seen_node_map;

  my $count = 0;

  for my $el (@{$connects}) {
    next if $el eq $start;
    if($el eq $end) {
      ++$count;
      next;
    }

    # Check if any key has the value >= 2.
    # If so, then only exist once.
    # Else you can also go to twice.
    if(is_max_visited($seen_node_map)) {
      next if($seen_node_map->{$el} && $seen_node_map->{$el} ge 1);
    } else {
      next if($seen_node_map->{$el} && $seen_node_map->{$el} ge 2);
    }


    if(is_small($el)) {
      # dump $indent, "checking", $el;
      my $next_seen_node_map = { %$seen_node_map };
      if($next_seen_node_map->{$el}) {
        $next_seen_node_map->{$el} = $next_seen_node_map->{$el} + 1;
      } else {
        $next_seen_node_map->{$el} = 1;
      }
      # dump $indent, $next_seen_node_map;
      $count += part_two($connections{$el}, $start, $end, $next_seen_node_map, $indent."  ", $iterations + 1);
    } else {
      # dump $indent, "checking", $el;
      $count += part_two($connections{$el}, $start, $end, $seen_node_map, $indent."  ", $iterations + 1);
    }
  }

  return $count;
}

my $file = 'input.txt';
open my $data, $file or die "Could not open $file: $!";

while( my $line = <$data>)  {
  chomp($line);
  my ($s, $e) = split('-', $line);
  # next if(is_small($s) && is_small($e)); 

  if(exists $connections{$s}) {
    push @{ $connections{$s} }, $e;
  } else {
    @connections{$s} = [$e];
  }

  if(exists $connections{$e}) {
    push @{ $connections{$e} }, $s;
  } else {
    @connections{$e} = [$s];
  }
}

dump part_one($connections{"start"}, "start", "end", [], "");

my %seen_node_map;
dump part_two($connections{"start"}, "start", "end", \%seen_node_map, "", 0);

close $data;
