import serial.tools.list_ports
import time
import firebase_admin
from datetime import datetime
from firebase_admin import credentials, db

# datetime object containing current date and time
now = datetime.now()
# dd/mm/YY H:M:S
dt_string = now.strftime("%d/%m/%Y %H:%M:%S")

cred = credentials.Certificate("smarthome-comeherebae-firebase-key.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': "https://smarthome-comeherebae-default-rtdb.firebaseio.com/"
})

temp = db.reference('/')


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
user = db.reference("user")
fire = db.reference("fire")


def processData(data):
    data = data.replace("!", "")
    data = data.replace("#", "")
    splitData = data.split(":")
    if (int(splitData[2]) <= 100 and int(splitData[2]) > 0):
        print(splitData)
    try:
        if splitData[1] == "TEMP":
            if (int(splitData[2]) <= 100 and int(splitData[2]) > 0):
                temp.update({
                    "value": int(splitData[2]),
                    "date and time": dt_string
                })
            data_user = user.get()
            data_fire = fire.get()
            print("state fire: " + str(data_fire["state"]))
            if data_user["userControl"] == 0:
                if (int(splitData[2]) > 36 or data_fire["state"] == 1):
                    pump.update({
                        "state": 1
                    })
                    ser.write("1#".encode())
                else:
                    pump.update({
                        "state": 0
                    })
                    ser.write("0#".encode())
            else:
                data = pump.get()
                ser.write((str(data["state"]) + "#").encode())
        else:
            print("Undefined Type")
    except Exception as e:
        print(e)


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
        try:
            readSerial()
        except Exception as e:
            print(e)
    time.sleep(0.5)
