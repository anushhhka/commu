const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.checkAndSendNotifications = functions.pubsub
    .schedule("every 24 hours")
    .onRun(async (context) => {
      const db = admin.firestore();
      const messaging = admin.messaging();
      const today = new Date();
      const todayString = `${today.getMonth() + 1}-${today.getDate()}`;

      try {
      // Get all documents from the users collection
        const usersSnapshot = await db.collection("users").get();
        const usersToNotify = [];

        for (const userDoc of usersSnapshot.docs) {
        // Get the 'niyani' subcollection for each user document
          const niyaniSnapshot = await userDoc.ref.collection("niyani").get();

          for (const niyaniDoc of niyaniSnapshot.docs) {
          // Get the user_details subcollection for each 'niyani' document
            const userDetailsSnapshot = await niyaniDoc.ref
                .collection("user_details")
                .get();

            userDetailsSnapshot.forEach((doc) => {
              const data = doc.data();
              const dob = data["Date of Birth"] ?
              new Date(data["Date of Birth"].seconds * 1000) :
              null;
              const marriageDate = data["Marriage Date"] ?
              new Date(data["Marriage Date"].seconds * 1000) :
              null;
              let phoneNumber = data["Mobile Number/Whatsapp Number"];

              // Ensure the phone number starts with '91'
              if (!phoneNumber.startsWith("91")) {
                phoneNumber = "91" + phoneNumber;
              }

              if (
                (dob &&
                `${dob.getMonth() + 1}-${dob.getDate()}` === todayString) ||
              (marriageDate &&
                `${marriageDate.getMonth() + 1}-${marriageDate.getDate()}` ===
                  todayString)
              ) {
                usersToNotify.push(phoneNumber);
              }
            });
          }
        }

        if (usersToNotify.length > 0) {
        // Get mobile tokens for users to notify
          const tokensSnapshot = await db
              .collection("mobile_tokens")
              .where(admin.firestore.FieldPath.documentId(),
                  "in", usersToNotify)
              .get();
          const tokens = tokensSnapshot.docs.map((doc) => doc.data().token);

          if (tokens.length > 0) {
          // Send notifications
            const message = {
              notification: {
                title: "Special Day Reminder",
                body: "Today is your special day! Best wishes from our team.",
              },
            };

            const response = await messaging.sendEachForMulticast({
              tokens: tokens,
              ...message,
            });

            console.log("Notifications sent:", response.successCount);
          } else {
            console.log("No tokens found for users to notify.");
          }
        } else {
          console.log("No users to notify today.");
        }
      } catch (error) {
        console.error("Error sending notifications:", error);
      }
    });

exports.sendNotification = functions.https.onCall((data, context) => {
  try {
    const token = data.token;
    const payload = {
      notification: {
        title: data.title,
        body: data.body,
        clickAction: "FLUTTER_ACTION_CLICK",
      },
    };
    return admin
        .messaging()
        .sendToDevice(token, payload)
        .then((response) => {
          return {
            success: true,
            response: `Successful ${response}`,
          };
        })
        .catch((error) => {
          return {
            success: false,
            response: `Error ${error}`,
          };
        });
  } catch (error) {
    console.log(`Some Error Occurred ${error}`);
    return {
      success: false,
      response: `Error ${error}`,
    };
  }
});
