import serial.tools.list_ports
import time
import sys

from Adafruit_IO.mqtt_client import MQTTClient

AIO_FEED_IDS = "bbc-led"
AIO_USERNAME = "nguyenhoang1442001"
AIO_KEY = "aio_aqRy94UfaTZRIXc4RFvDdz3oRhoS"


def connected(client):
    print("Successful connected...")
    client.subscribe(AIO_FEED_IDS)


def subscribe(client, userdata, mid, granted_qos):
    print("Successful connected...")


def disconnected(client):
    print("Cut the connection")
    sys.exit(1)


def message(client, feed_id, payload):
    print("Receive the data: " + payload)
    if isMicrobitConnected:
        ser.write((str(payload) + "#").encode())


client = MQTTClient(AIO_USERNAME, AIO_KEY)
client.on_connect = connected
client.on_disconnect = disconnected
client.on_message = message
client.on_subscribe = subscribe
client.connect()
client.loop_background()


def getPort():
    ports = serial.tools.list_ports.comports()
    N = len(ports)
    commPort = "None"
    for i in range(0, N):
        port = ports[i]
        strPort = str(port)
        if "USB Serial Device" in strPort:
            splitPort = strPort.split(" ")
            commPort = (splitPort[0])
    return commPort


isMicrobitConnected = False
if getPort() != "None":
    ser = serial.Serial(port=getPort(), baudrate=115200)
    isMicrobitConnected = True


def processData(data):
    data = data.replace("!", "")
    data = data.replace("#", "")
    splitData = data.split(":")
    print(splitData)
    try:
        if splitData[1] == "TEMP":
            client.publish("bbc-temp", splitData[2])
    except:
        pass

mess = ""


def readSerial():
    bytesToRead = ser.inWaiting()
    if bytesToRead > 0:
        global mess
        mess = mess + ser.read(bytesToRead).decode("UTF-8")
        while ("#" in mess) and ("!" in mess):
            start = mess.find("!")
            end = mess.find("#")
            processData(mess[start:end + 1])
            if end == len(mess):
                mess = ""
            else:
                mess = mess[end + 1:]


while True:
    if isMicrobitConnected:
        readSerial()
    time.sleep(1)
