// constants won't change. They're used here to
// set pin numbers:
const int buttonPin[] = {2, 3, 4, 5};  // the number of the pushbutton pins
const int ledPin =  13;      // the number of the LED pin

// variables will change:
int buttonState = 0;         // variable for reading the pushbutton status

void setup() {
  //initialize serial communications at a 9600 baud rate
  Serial.begin(9600);
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);
  // initialize the pushbutton pin as an input:
  for (int x = 0; x < 4; x++)
  {
    pinMode(buttonPin[x], INPUT);
  }
}

void loop() {
  // read the state of the pushbutton value:
  for (int x = 0; x < 4; x++)
  {
    buttonState = digitalRead(buttonPin[x]);

    // check if the pushbutton is pressed.
    // if it is, the buttonState is HIGH:
    if (buttonState == HIGH && buttonPin[x] == 2) {
      // turn LED on:
      digitalWrite(ledPin, HIGH);
      Serial.println('l');
      delay(200);
    }
    if (buttonState == HIGH && buttonPin[x] == 3) {
      // turn LED off:
      digitalWrite(ledPin, HIGH);
      Serial.println('u');
      delay(200);
    }
    if (buttonState == HIGH && buttonPin[x] == 4) {
      // turn LED off:
      digitalWrite(ledPin, HIGH);
      Serial.println('d');
      delay(200);
    }
    if (buttonState == HIGH && buttonPin[x] == 5) {
      // turn LED off:
      digitalWrite(ledPin, HIGH);
      Serial.println('r');
      delay(200);
    }
    else {
      digitalWrite(ledPin, LOW);
    }
    
  }
}
