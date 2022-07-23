const functions = require("firebase-functions");

const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

exports.sendNotification = functions.firestore.document('Fall-Detections/{docId}').onCreate(async (snapshot, context) => {
    const value = snapshot.data();

    // Get list of tokens for active (on shift) users
    const users = await db.collection('Registration Token').get();

    const workingUsers = await db.collection('Employees').where('working', '==', true).get();
    const workingIds = workingUsers.docs.map(doc => doc.id);

    let tokens = [];
    users.forEach(user => {
        if (workingIds.includes(user.id)) {
            tokens.push(user.data().registrationToken);
        }
    });

    // Get device information for notification
    const currentDevice = await db.collection('Devices').doc(context.params.docId).get();

    const room = currentDevice.get('Device')['room number'];
    const bed = currentDevice.get('Device')['bed number'];

    const text = 'Room: ' + room + ', Bed: ' + bed;

    // Notification details.
    const payload = {
        notification: {
            title: 'Fall Detected!',
            body: text
        },
        data: {
            title: 'Fall detected!',
            room: room,
            bed: bed,
            device: context.params.docId
        }
    }; 

    // Send notifications to all relevant tokens.
    const response = await admin.messaging().sendToDevice(tokens, payload);

    // Write log to database
    await db.collection('Notifications').add(
        {
            text: text,
            device : currentDevice.id,
            room : room,
            bed : bed,
            description : 'Fall detected - Notification sent', 
            timestamp: new Date().toISOString(),
            users : workingIds // list users Ids for clarity
        });

    await db.collection("Fall-Detections").doc(context.params.docId).delete();
})
