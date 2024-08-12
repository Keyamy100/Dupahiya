// Variable to store function returns
uint8_t data_read;
float amb_temp;
float target_temp = 250;
uint16_t par_t1;
uint16_t par_t2;
uint8_t par_t3;
uint32_t temp_adc;
uint8_t par_t1_l;
uint8_t par_t1_m;
uint8_t par_t2_l;
uint8_t par_t2_m;
uint8_t temp_adc_m;
uint8_t temp_adc_l;
uint8_t temp_adc_x;

float var1;
float var2;
float var3;
float t_fine;
float temp_comp;

void setup()
{
  //////////////////////////
  // 1. Start the I2C bus
  //////////////////////////
  I2C.begin();

  ////////////////////////////////////////////////////////
  // Power on the socket
  ////////////////////////////////////////////////////////
  // Connect device Vcc pin to the 3V3 SENSOR POWER pin
  // If the device requiers 5V power supply, the 5V SENSOR
  // POWER pin may be enabled with:
  // PWR.setSensorPower(SENS_5V, SENS_ON);
  ////////////////////////////////////////////////////////
  PWR.setSensorPower(SENS_3V3, SENS_ON);
}

void loop()
{
  ///////////////////////////////////////////////////////////
  // 2. Read data from slave device connected to the I2C bus
  ///////////////////////////////////////////////////////////
  // 0x77 -> slave device address
  // 0xD0 -> register address to read data from
  // data_read -> variable to store data read
  // 1 -> size of data read
  //I2C.read(0x77, (uint8_t)0xE9, &par_t1_l, 1);
  //I2C.read(0x77, (uint8_t)0xEA, &par_t1_m, 1);
  //I2C.read(0x77, (uint8_t)0x8A, &par_t2_l, 1);
  //I2C.read(0x77, (uint8_t)0x8B, &par_t2_m, 1);
  //I2C.read(0x77, (uint8_t)0x8C, &par_t3, 1);
  //
  //par_t1 = (par_t1_m<<4) | par_t1_l;
  //par_t1 = (par_t2_m<<4) | par_t2_l;
  ////uint32_t raw_temp = (par_t1_m << 16) | (par_t1_l << 12) | (par_t2_m << 8) | (par_t2_l << 4) | (par_t3 << 4);
  ////USB.println(par_t1);
  ////USB.println(par_t2);
  ////USB.println(par_t3);
  //var1 = (((double)temp_adc / 16384.0) - ((double)par_t1 / 1024.0)) * (double)par_t2;
  //var2 = ((((double)temp_adc / 131072.0) - ((double)par_t1 / 8192.0)) *
  //(((double)temp_adc / 131072.0) - ((double)par_t1 / 8192.0))) *
  //((double)par_t3 * 16.0);
  //t_fine = var1 + var2;
  //temp_comp = t_fine / 5120.0;
  //
  //USB.println(var1);
  //USB.println(var2);
  //USB.println(var3);
  //USB.println(t_fine);
  //USB.println(temp_comp);
  //USB.println(temp_comp);

  //var1 = hum_adc - (((double)par_h1 * 16.0) + (((double)par_h3 / 2.0) * temp_comp));
  //var2 = var1 * (((double)par_h2 / 262144.0) * (1.0 + (((double)par_h4 / 16384.0) *
  //temp_comp) + (((double)par_h5 / 1048576.0) * temp_comp * temp_comp)));
  //var3 = (double)par_h6 / 16384.0;
  //var4 = (double)par_h7 / 2097152.0;
  //hum_comp = var2 + ((var3 + (var4 * temp_comp)) * var2 * var2);
  uint8_t valueID;

  I2C.read(0x77, (uint8_t)0xD0, &valueID, 1);

  if (valueID == 0x61)
  {
    USB.println("OK");
  }

  I2C.read(0x77, (uint8_t)0xE9, &par_t1_l, 1);
  I2C.read(0x77, (uint8_t)0xEA, &par_t1_m, 1);
  I2C.read(0x77, (uint8_t)0x8A, &par_t2_l, 1);
  I2C.read(0x77, (uint8_t)0x8B, &par_t2_m, 1);
  I2C.read(0x77, (uint8_t)0x8C, &par_t3, 1);
  I2C.read(0x77, (uint8_t)0x22, &temp_adc_m, 1);
  I2C.read(0x77, (uint8_t)0x23, &temp_adc_l, 1);
  I2C.read(0x77, (uint8_t)0x24, &temp_adc_x, 1);

  USB.print("TEMP ADC M :");
  USB.println(temp_adc_m, HEX);

  USB.print("TEMP ADC L :");
  USB.println(temp_adc_l, HEX);

  USB.print("TEMP ADC X :");
  USB.println(temp_adc_x, HEX);


  temp_adc = (uint32_t)(temp_adc_m << 12) | (uint32_t)(temp_adc_l << 4) | (uint32_t)(temp_adc_x);


  par_t1 = (par_t1_m << 8) | par_t1_l;

  par_t2 = (par_t2_m << 8) | par_t2_l;

  var1 = (((double)temp_adc / 16384.0) - ((double)par_t1 / 1024.0)) * (double)par_t2;
  var2 = ((((double)temp_adc / 131072.0) - ((double)par_t1 / 8192.0)) *
          (((double)temp_adc / 131072.0) - ((double)par_t1 / 8192.0))) *
         ((double)par_t3 * 16.0);
  t_fine = var1 + var2;
  temp_comp = t_fine / 5120.0;

  USB.println(temp_comp);

  delay(10000);
}
