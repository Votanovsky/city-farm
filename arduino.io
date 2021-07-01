// объявление библиотек
#include <MHZ.h> // берется из примера MH-Z19B 
#include <DHT.h> // берется из примера DHTtester
#include <RTC.h> // берется из любого примера RTC 

// объявление переменных
// номера отвечают за пины, к которым подключены датчики
#define pump 4 //насос

//свет
#define led_1 5 // первая лампа
#define led_2 6 // вторая лампа
#define led_3 7 // третья лампа

#define CO2_IN 13 // датчик CO2
#define DHTPIN 12 // датчика влажности и температуры(к какому сигналу подключено)
#define DHTTYPE DHT22 //тип датчика влажности и температуры (берётся из примера DHTtester)

//датчики воды (номера сигналов)
#define water_1 10 //первый датчик воды
#define water_2 11 //второй датчик воды

//включение и выключение датчиков
#define led_1_ON "ON1" // включение первой лампы по фразе ON1
#define led_2_ON "ON2" // включение второй лампы по фразе ON2
#define led_3_ON "ON3" // включение третьей лампы по фразе ON3

#define led_1_OFF "OFF1" // выключение первой лампы по фразе ON1
#define led_2_OFF "OFF2" // выключение второй лампы по фразе ON2
#define led_3_OFF "OFF3" // выключение третьей лампы по фразе ON3

#define pump_on "pump_on" // включение насоса по фразе pump_on
#define pump_off "pump_off" // выключение насоса по фразе pump_off

String message; // Переменная ввода команд на COM-терминале


// объявление датчиков
DHT dht(DHTPIN, DHTTYPE); // это копируем из примера DHT Tester (Объявление датчика MH-Z19B для CO2)
MHZ co2(CO2_IN, MHZ19B); // это копируем из примера MHZ-CO2 Sensors (Объявление датчика DHT для влажности и температуры)
static DS3231 RTC;// берется из любого примера RTC ( Объявление датчика времени)

void Done() // Функция сигнализирующая выполнение команды и ожидания следующей
{
  Serial.print("\n");
  Serial.println("Команда выполнена. Для дальнейшей работы введите новую команду...");
}

//Показывает углекислый газ
void CO2show()
{
  Serial.println("CO2: " + String(co2.readCO2PWM())); // берется из примера MH-Z19B в части loop где ppm_pwm
}

//Показывает время

void Timeshow() //Берется из примера RTC DS3231 info (часть вывод дд.мм.гг, чч.мм.сс)
{
  Serial.println(
  "Date: " +
  String(RTC.getDay()) + "." +
  String(RTC.getMonth()) + "." +
  String(RTC.getYear()) + "\n" + "Time: " +
  String(RTC.getHours()) + ":" +
  String(RTC.getMinutes()) + ":" +
  String(RTC.getSeconds())
  );
}

 /*Влажность и температура берется из примера DHT tester в части
loop где объявляются переменные и выводятся на экран*/

//Показывает влажность

void GetHumidity()
{
  Serial.println(
  "Влажность: " +
  String(dht.readHumidity()) + "%"
  );
}

//Показывает температуру

void GetTemp()
{
  Serial.println("Температура: " +
  String(dht.readTemperature()) + "°C"
  );
}

//Дальше пишем функции сами
//Показывает наличие воды

void Watershow() 
{
  if 
  (
    digitalRead(water_1) == 1 || 
    digitalRead(water_2) == 1
  )
  {
    Serial.println("В баке есть вода");
  }
  else
  {
    Serial.println("В баке нет воды");
  }
}

void TurnOnPump()
  {
    digitalWrite(pump, HIGH);
  }

void TurnOffPump()
  {
    digitalWrite(pump, LOW);
  }

//Включить весь свет

void TurnOnAllLight()
  {
    digitalWrite(led_1, HIGH);
    digitalWrite(led_2, HIGH);
    digitalWrite(led_3, HIGH);
  }

//Включить первую лампу

void Lamp_1_On()
  {
    digitalWrite(led_1, HIGH);
  }

//Включить вторую лампу

void Lamp2_On()
  {
  digitalWrite(led_2, HIGH);
  }

//Включить третью лампу

void Lamp3_On()
  {
    digitalWrite(led_3, HIGH);    
  }

//Выключить весь свет

void TurnOffAllLight()
  {
    digitalWrite(led_1, LOW);
    digitalWrite(led_2, LOW);
    digitalWrite(led_3, LOW);
  }

//Выключить первую лампу

void Lamp_1_Off()
  {
    digitalWrite(led_1, LOW);
  }

//Выключить вторую лампу

void Lamp_2_Off()
  {
    digitalWrite(led_2, LOW);
  }

//Выключить третью лампу

void Lamp_3_Off()
  {
    digitalWrite(led_3, LOW);
  }

void ShowAll()
  {
    Serial.println();
    Timeshow();
    delay(1000);
    Serial.println();
    
    CO2show();
    delay(1000);
    Serial.println();

    GetHumidity();
    delay(1000);
    Serial.println();

    GetTemp();
    delay(1000);
    Serial.println();

    Watershow();
    delay(1000);
    Serial.println();
  }

void check_user_command()
{
  while (Serial.available() > 0)
  {
  message = Serial.readString();

  if(message == "All")
  {
    Serial.print("Выводим все данные...");
    ShowAll();
    delay(1000);
    Done();
  }
  else if(message == "CO2")
  {
    Serial.print("Данные датчика СО2");
    CO2show();
    delay(1000);
    Done();
  }

  else if(message == "Time")
  {
    Serial.print("Актуальные дата и время:");
    Timeshow();
    delay(1000);
    Done();
  }
  else if(message == "Humidity" || message == "Vlaga")
  {
    Serial.print("Процент влажности:");
    GetHumidity();
    delay(1000);
    Done();
  }

  else if(message == "water")
  {
    Serial.print("Данные с датчиков воды:");
    Watershow();
    delay(1000);
    Done();
  }

  else if(message == "TurnOnLights")
  {
    Serial.print("Свет включён");
    TurnOnAllLight();
    delay(1000);
    Done();
  }

  else if(message == "TurnOffLights")
  {
    Serial.print("Свет выключён");
    TurnOffAllLight();
    delay(1000);
    Done();
  }
  
 else if(message == "TurnOnFirstLamp")
  {
    Serial.print("Первая лампа включена.");
    Lamp_1_On();
    delay(1000);
    Done();
  }

   else if(message == "TurnOnSecondLamp")
  {
    Serial.print("Вторая лампа включена.");
    Lamp_2_On();
    delay(1000);
    Done();
  }

   else if(message == "TurnOnThirdLamp")
    {
      Serial.print("Третья лампа включена.");
      Lamp_3_On();
      delay(1000);
      Done();
    }

    else if(message == "TurnOffFirstLamp")
    {
      Serial.print("Первая лампа выключена.");
      Lamp_1_Off();
      delay(1000);
      Done();
    }

   else if(message == "TurnOffSecondLamp")
    {
      Serial.print("Вторая лампа выключена.");
      Lamp_2_Off());
      delay(1000);
      Done();
    }
  
   else if(message == "TurnOffThirdLamp")
    {
      Serial.print("Третья лампа выключена.");
      Lamp_3_Off();
      delay(1000);
      Done();
    }
  
  }
}

void Light_Time() // Вкключает или выключает свет в зависимости от времени
{
  if ((String(RTC.getHours()) > "09" && String(RTC.getHours()) < "18")
  {
    TurnOnAllLight();
  }

  else if (String(RTC.getHours()) > "18" && String(RTC.getHours()) <"09")
  {
   TurnOffAllLight();
  }
}


void dayVremy()
{
  RTC.setHourMode(CLOCK_H24);
  RTC.setDateTime(__DATE__, __TIME__);
  RTC.startClock();
}
 
void Pump_In() // Автополив
 
  if 
  (
    String(String(RTC.getHours()) + ":" + String(RTC.getMinutes())) > "14:27" && 
    String(String(RTC.getHours()) + ":" + String(RTC.getMinutes())) < "14:29"
  )
 
  {
    TurnOnPump()
  }
 
  else if 
  (
    String(String(RTC.getHours()) + ":" + String(RTC.getMinutes())) > "14:28" || 
    String(String(RTC.getHours()) + ":" + String(RTC.getMinutes())) < "14:27"
  )
 
  {
   TurnOffPump()
  }
}
void setup() 
{
  // put your setup code here, to run once:
  Serial.begin(9600);
  RTC.begin();
  dht.begin();
 
  pinMode(CO2_IN, INPUT);
  pinMode(DHTPIN, INPUT);
  pinMode(led_1, OUTPUT);
  pinMode(led_2, OUTPUT);
  pinMode(led_3, OUTPUT); 
  pinMode (water_1, INPUT);
  pinMode (water_2, INPUT);
 
  digitalWrite(led_1, LOW);
  digitalWrite(led_2, LOW);
  digitalWrite(led_3, LOW);

  dayVremy();
 
}

void loop() {
  // put your main code here, to run repeatedly:
  check_user_command();
  delay(3000);
  
}
