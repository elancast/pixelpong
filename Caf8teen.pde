// Copyright 2012-present Facebook. All Rights Reserved.

import com.heronarts.lx.*;
import com.heronarts.lx.kinet.*;
import com.heronarts.lx.modulator.*;
import com.heronarts.lx.pattern.*;
import com.heronarts.lx.transition.*;
import com.heronarts.lx.indirection.*;
import ddf.minim.*;

final int numInnerColumns = 111;
final color fbBlue = #3b5998;
final int dishNicheHeight = 5;
final int dishNicheOffset = 17;
final int dishNicheWidth = 18;

int nodeWidth = 190;
int nodeHeight = 24;
int simulationScale = 6;
int simulationGap = 40;


HeronLX lx;
KinetNode[] nodes;
boolean kinetActive = false;

void setup() {
  size(nodeWidth*simulationScale + simulationGap, nodeHeight*simulationScale);
  lx = new HeronLX(this, nodeWidth, nodeHeight);
  lx.setPatterns(new LXPattern[] {
    new BaseHuePattern(lx),
  });
  lx.tempo.setBpm(60);
  
  final String[] psus = {
    "10.3.201.178",
    "10.3.201.162",
    "10.3.201.189",
    "10.3.201.160",
    "10.3.201.156",
    "10.3.201.184",
  };
  final int portsPerPsu = 16;
  final KinetPort[] ports = new KinetPort[psus.length*portsPerPsu];
  for (int i = 0; i < psus.length; ++i) {
    for (int j = 0; j < portsPerPsu; ++j) {
      ports[i*portsPerPsu + j] = new KinetPort(psus[i], j+1);
    }
  }
  nodes = new KinetNode[lx.total];
  for (int i = 0; i < nodes.length; ++i) {
    nodes[i] = null;
    int row = lx.row(i);
    int col = lx.column(i);
    if (col < 17) {
      // Inner Tube left section
      int portIndex = col/2;
      int nodeIndex = (col % 2 == 0) ? (lx.height - 1 - row) : (lx.height + row);
      nodes[i] = new KinetNode(ports[portIndex], nodeIndex);
    } else if (col < 35) {
      // Dish Niche
      if (row < 5) {
        int portIndex = (col < 26) ? 9 : 10;
        int colIndex = (col < 26) ? (col-17) : (col-26);
        int nodeIndex = colIndex * 5 + ((colIndex % 2 == 0) ? (4 - row) : row);
        nodes[i] = new KinetNode(ports[portIndex], nodeIndex);
      } else {
        // There are no physical nodes in the dish niche
        nodes[i] = null;
      }
    } else if (col < numInnerColumns) {
      // Inner Tube right section
      int portIndex = 11 + (col - 35) / 2;
      int nodeIndex = (col % 2 == 1) ? (lx.height - 1 - row) : (lx.height + row);
      switch (col) {
        case 45:
        case 57:
        case 79:
        case 101:
          nodeIndex = row;
          break;
        case 46:
        case 58:
        case 80:
        case 102:
          nodeIndex = 2*lx.height-1-row;
          break;
      }      
      nodes[i] = new KinetNode(ports[portIndex], nodeIndex);
    } else {
      // Outer tube
      int portIndex = 49 + (col - numInnerColumns) / 2;
      int nodeIndex = (col % 2 == 1) ? (lx.height - 1 - row) : (lx.height + row);
      switch (col) {
        case 133:
        case 155:
        case 177:
          nodeIndex = row;
          break;
        case 134:
        case 156:
        case 178:
          nodeIndex = 2*lx.height-1-row;
          break;        
      }
      nodes[i] = new KinetNode(ports[portIndex], nodeIndex);
    }
  }
  
  lx.setPatterns(new LXPattern[] {
    new TestConnection(lx),
    new Droplets(lx),
  });
  
  background(0);
  noStroke();
  stroke(#202020);
  fill(#191919);
  rect(numInnerColumns*simulationScale, 0, simulationGap, height);
  rect(dishNicheOffset*simulationScale, dishNicheHeight*simulationScale, dishNicheWidth*simulationScale, height);
  
  println("Caf8teen initialized, press 'k' to toggle live lighting output");
}

void draw() {
  // Triggers the engine runloop
}

void keyPressed() {
  switch (key) {
    case 'k':
      kinetActive = !kinetActive;
      if (kinetActive) {
        lx.setKinetNodes(nodes);
      } else {
        lx.setKinetNodes(null);
      }
      println("Kinet live output " + (kinetActive ? "enabled" : "disabled"));
  }
}

