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

temp.set({
    'temperature': {
        'value': 24,
        'name': 'smart home',
        'date and time': '25/06/2021 07:58:56'
    },
    'pump':
        {
            'state': 0
        }

})

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
    print(splitData)
    try:
        if splitData[1] == "TEMP":
            temp.update({
                "value": splitData[2],
                "date and time": dt_string
            })
            # if int(splitData[2]) > 20:
            #     pump.update({
            #         "state": 1
            #     })
            data = pump.get()
            ser.write((str(data["state"]) + "#").encode())
            # else:
            #     pump.update({
            #         "state": 0
            #     })
            #     data = pump.get()
            #     ser.write((str(data["state"])+"#").encode())
        else:
            print("Undefined State")
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
        readSerial()
    time.sleep(0.5)
