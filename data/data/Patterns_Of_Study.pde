
Table data;

String[] periods = {
  "Morning", "Afternoon", "Evening", "Late Night"
};

int[] laneColours = {
  #F4B183, #79B9D8, #B49ADB, #8BC6A8
};

void setup() {
  size(1200, 760);
  surface.setTitle("Study Patterns | Dear Data");

  // Load the CSV file
  data = loadTable("study_sessions.csv", "header");

  if (data == null) {
    println("ERROR: CSV file not found!");
    println("Place study_sessions.csv inside the data folder.");
    return;
  }

  println("CSV successfully loaded!");
  println("Total observations: " + data.getRowCount());
}

void draw() {
  background(#171C2B);

  if (data == null) {
    fill(255);
    textAlign(CENTER);
    textSize(22);
    text("CSV file not found. Check your data folder.", width/2, height/2);
    return;
  }

  drawHeader();
  drawSummary();
  drawLanes();
  drawLegend();
}

void drawHeader() {
  fill(#FFFFFF);
  textAlign(LEFT);
  textSize(34);
  text("STUDY PATTERNS", 55, 65);

  fill(#AAB3C5);
  textSize(15);
  text("A visual diary of my study habits and productivity", 57, 95);

  stroke(#394257);
  line(55, 120, 1145, 120);
}

void drawSummary() {
  int totalMinutes = 0;
  int totalTasks = 0;
  int activeSessions = 0;

  for (TableRow row : data.rows()) {
    int minutes = row.getInt("study_minutes");

    totalMinutes += minutes;
    totalTasks += row.getInt("tasks_completed");

    if (minutes > 0) {
      activeSessions++;
    }
  }

  fill(#242C40);
  noStroke();
  rect(55, 145, 1090, 105, 15);

  fill(#FFFFFF);
  textSize(25);
  text(totalMinutes + " min", 85, 190);
  text(activeSessions, 385, 190);
  text(totalTasks, 685, 190);
  text(data.getRowCount(), 935, 190);

  fill(#AAB3C5);
  textSize(13);
  text("TOTAL STUDY TIME", 85, 220);
  text("ACTIVE PERIODS", 385, 220);
  text("TASKS COMPLETED", 685, 220);
  text("OBSERVATIONS", 935, 220);
}

void drawLanes() {
  float startY = 300;
  float laneHeight = 83;
  float startX = 220;
  float spacing = 88;

  for (int i = 0; i < periods.length; i++) {

    float y = startY + i * laneHeight;

    // Time-of-day label
    fill(laneColours[i]);
    textAlign(LEFT);
    textSize(15);
    text(periods[i], 65, y + 5);

    // Lane background
    fill(#222A3D);
    noStroke();
    rect(startX, y - 27, 875, 55, 12);

    // Draw each observation
    for (TableRow row : data.rows()) {

      String period = row.getString("time_of_day");

      if (period.equals(periods[i])) {

        int session = row.getInt("session_id");
        int minutes = row.getInt("study_minutes");
        int rating = row.getInt("productivity_rating");

        float x = startX + (session - 1) * spacing;

        float diameter = map(minutes, 0, 40, 12, 43);

        if (minutes == 0) {
          diameter = 10;
        }

        // Productivity controls colour
        color bubbleColour;

        if (minutes == 0) {
          bubbleColour = #647084;
        } else {
          float level = constrain(rating / 7.0, 0, 1);
          bubbleColour = lerpColor(
            #E99B78, #8BC6A8, level
          );
        }

        // Draw observation circle
        fill(bubbleColour);
        stroke(#FFFFFF, 170);
        strokeWeight(1.2);
        ellipse(x, y, diameter, diameter);

        // Display study duration
        if (minutes > 0) {
          fill(#FFFFFF);
          textAlign(CENTER);
          textSize(10);
          text(minutes, x, y + 4);
        }
      }
    }
  }

  // Session numbers
  fill(#AAB3C5);
  textSize(11);
  textAlign(CENTER);

  for (int i = 0; i < 10; i++) {
    text("Day " + (i + 1),
      startX + i * spacing, 650);
  }

  fill(#AAB3C5);
  textSize(12);
  textAlign(CENTER);
  text("STUDY SESSIONS", 650, 675);
}

void drawLegend() {
  fill(#FFFFFF);
  textAlign(LEFT);
  textSize(14);
  text("HOW TO READ THE DATA", 65, 710);

  fill(#8BC6A8);
  noStroke();
  ellipse(330, 705, 17, 17);

  fill(#AAB3C5);
  textSize(12);
  text("Higher productivity", 345, 709);

  fill(#E99B78);
  ellipse(510, 705, 17, 17);

  fill(#AAB3C5);
  text("Lower productivity", 525, 709);

  fill(#647084);
  ellipse(700, 705, 12, 12);

  fill(#AAB3C5);
  text("No study time", 715, 709);

  fill(#FFFFFF);
  text("Larger circles = more study minutes", 875, 709);
}
