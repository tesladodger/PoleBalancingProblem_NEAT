import com.tesladodger.neat.*;
import java.util.Random;

Innovation innov;
Population population;
Vehicle vehicle;

Random r;

void setup () {
  size(900, 500);
  frameRate(50); // Match the 50Hz of sample time.
  
  r = new Random();
  innov = new Innovation();
  vehicle = new Vehicle();
  
  population = new Population(2, 1, 1000, r, innov, vehicle);
  population.set_only_show_best(true);
  population.runSimulation(r, innov);
  population.printStats();
}

void draw () {
  background(255);
  
  // Draw the floor.
  fill(100);
  noStroke();
  rect(0, height-60, width, 60);
  rect(0, height-120, width/2 - vehicle.getTrackWidth()*50, 60);
  rect(width/2 + vehicle.getTrackWidth()*50, height-120, width/2 - vehicle.getTrackWidth()*50, 60);

  if (population.replayIndividualIsAlive()) {
    population.replayPreviousBest();
  }
  else {
    population.runSimulation(r, innov);
    population.printStats();
  }
}
