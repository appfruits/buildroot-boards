echo 37 >> /sys/class/gpio/export
echo "out" > /sys/class/gpio/pioB5/direction
echo 1 > /sys/class/gpio/pioB5/value
./gslx680 -res 800x480 -gpio /sys/class/gpio/pioB5 /dev/i2c-1 gsl1680firmware &
