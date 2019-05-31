import com.tesladodger.neat.*;
import java.util.Random;

Innovation innov;
Population population;
Vehicle vehicle;

Random r;

void setup () {
  size(900, 500);
  
  r = new Random();
  innov = new Innovation();
  vehicle = new Vehicle();
  
  population = new Population(4, 1, 150, r, innov, vehicle);
}

void draw () {
  background(255);
  
  // Draw the floor.
  fill(100);
  noStroke();
  rect(0, height-60, width, 60);
  rect(0, height-120, width/2 - vehicle.getTrackWidth()*50, 60);
  rect(width/2 + vehicle.getTrackWidth()*50, height-120, width/2 - vehicle.getTrackWidth()*50, 60);

  if (population.areAllDead()) {
    population.naturalSelection(r, innov);
    population.printStats();
  }
  else {
    population.updateAliveIndividuals();
  }
}
