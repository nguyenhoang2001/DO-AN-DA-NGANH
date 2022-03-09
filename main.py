import serial.tools.list_ports
import time
import sys
import firebase_admin
from Adafruit_IO.mqtt_client import MQTTClient

from firebase_admin import credentials, db

cred = credentials.Certificate("smarthome-comeherebae-firebase-key.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': "https://smarthome-comeherebae-default-rtdb.firebaseio.com/"
})

temp = db.reference('/')

temp.set({
    'temperature': {
        'value': 24,
        'name': 'smart home'
    },
    'pump':
        {
            'state': 0
        }

})

AIO_FEED_ID = "bbc-pump"
AIO_USERNAME = "nguyenhoang1442001"
AIO_KEY = "aio_qeiz49WRoSN1DE3TDUHxU3fXWAaZ"


def connected(client):
    print("Successful connected...")
    client.subscribe(AIO_FEED_ID)


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

temp = db.reference("temperature")
pump = db.reference("pump")


def processData(data):
    data = data.replace("!", "")
    data = data.replace("#", "")
    splitData = data.split(":")
    # print(splitData)
    try:
        # if splitData[1] == "TEMP":
        #     client.publish("bbc-temp", splitData[2])
        #     temp.update({
        #         "value": splitData[2]
        #     })
        if splitData[2] > 27:
            # ser.write((str(1) + "#").encode())
            print("i>27", splitData[2])
            pump.update({
                "state": 100
            })
        else:

            # ser.write((str(0) + "#").encode())
            print("i<27", splitData[2])
            pump.update({
                "state": 0
            })
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
    time.sleep(0.5)
