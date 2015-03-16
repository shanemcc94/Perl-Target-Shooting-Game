#!/usr/bin/perl 
use strict; 

use SDL; 
use SDL::Video; 
use SDLx::App; 
use SDL::Surface; 
use SDL::Rect; 
use SDL::Image; 
use SDL::Event; 
use SDL::Mouse; 
use SDLx::Text;
use SDL::GFX::Rotozoom;


my ($application, $background, $background_rect, $event, $exiting, $filename, $front,	$item_movex, $item_x, $item_y, $front_w, $front_h, $front_rect, $dest_rect, $back_rect, $game, $move_x, $num, $inf_move);
# First create a new App
$exiting=0;
$inf_move=0;
$application = SDLx::App->new(
	  title  => "Target Shooting",
	  width  => 800, # use same width as background image
	  height => 600, # use same height as background image
	  depth  => 32,
	  exit_on_quit => 1 # Enable 'X' button
);
# Add event handler for quit (covered also by 'q' of 'x' from keyboard)
$application->add_event_handler( \&quit_event );
# Load an image for the background
# If the program is run without an available image the error
#  "Can't call method "w" on an undefined value at ThisFile.pl line XX."
# will be received.
$background = SDL::Image::load('background.jpg');
# Create a rectangle for the background image
$background_rect = SDL::Rect->new(0,0,
$background->w,
$background->h,
);
# Create a new event structure variable
$event = SDL::Event->new();
# Draw the background

# Update the window


$front = SDL::Image::load('target.png');
$item_x=300;
$item_y=300;
$front_w = $front->w;
$front_h = $front->h; 
#$front_rect = SDL::Rect->new($item_x, $item_y,$front_w,$front_h,);
SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
SDL::Video::blit_surface ($front, $front_rect, $application, $front_rect);
SDL::Video::update_rects($application, $background_rect, $front);
# Draw the image

# Update the window
SDL::Video::update_rects($application);
SDL::Events::enable_key_repeat( 25, 25 );
while ( !$exiting ) {
	$application->update;
	# Update the queue to recent events
	SDL::Events::pump_events();
	# process all available events
	while (SDL::Events::poll_event($event)) {
	  # check by Event type      
	  if ($event->type == SDL_QUIT) {
	    &quit_event(); 
	  }
	    elsif ($event->type == SDL_KEYDOWN) {
	      &key_event($event);
	    }
			  elsif ($event->type == SDL_MOUSEBUTTONDOWN) {
			    &mouse_event($event);	  
          SDL::Video::update_rects($application);
	       }
	}
	SDL::Video::update_rects($application);
	# slow things down if required
	#$application->delay(100);
} # game loop

sub quit_event {
	exit;
}

sub key_event {
	# printed output from here is going to the CLI
	print "Key is: ";
	my $key_name = SDL::Events::get_key_name( $event->key_sym );  
	print "[$key_name]\n";
  if (($key_name eq "q") || ($key_name eq "Q") ) {
	}
	if (($key_name eq "x") || ($key_name eq "X") ) {
	  $exiting = 1;
	}

	if (($key_name eq "h") || ($key_name eq "H") ) {
	  for(my $x=1;$x<=800;$x+=25){
      &move_target($x, $item_y);
    }

#		SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
	} 

 	if ($key_name eq "right") {
		$item_x += 25;
		if ($item_x>700){
      $item_x-=800;
    }
	  &move_target($item_x, $item_y);
  } 

  if ($key_name eq "left") {
		$item_x -= 25;
     if ($item_x<50){
       $item_x+=800;
     }
     &move_target($item_x, $item_y)
  }
	if ($key_name eq "down") {
	  $item_y+=25;
    if ($item_y>500){
      $item_y-=600;
    }  
	  &move_target($item_x, $item_y);
	}

  if ($key_name eq "up") {
    $item_y-=25;
	 # re-draw the background
    if ($item_y<50){
      $item_y+=600;
    }
	  &move_target($item_x, $item_y);
  }
}
sub mouse_event {
		# printed output from here is going to the CLI
		print "Mouse: ";
		my ($mouse_mask,$mouse_x,$mouse_y)  = @{SDL::Events::get_mouse_state()};
		print "[$mouse_x, $mouse_y]\n";
}

sub move_target{
		my($x, $y);
	  ($x, $y)= @_;
		$dest_rect = SDL::Rect->new(
	  $x,
	  $y,
		$front_w,
		$front_h);     
#		SDL::Video::blit_surface($front, $front_rect, $application, $front_rect);
		SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
		SDL::Video::blit_surface($front, $front_rect, $application, $dest_rect );
		SDL::Video::update_rects($application, $background, $dest_rect);
}


