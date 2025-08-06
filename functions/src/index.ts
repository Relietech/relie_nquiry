import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import * as admin from 'firebase-admin';
import { Request, Response } from 'express';
import * as functions from 'firebase-functions';
import { DateTime } from 'luxon';


admin.initializeApp();

///Normal Notification
export const normalNotifications = onDocumentCreated(
  { region: 'us-central1', document: 'subscription/{company}/AppNotification/{docId}'},
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const notify = snapshot.data();
    const title = String(notify.title);
    const content = String(notify.msg);

    for (const topic of notify.topic) {
      const payload: admin.messaging.Message = {
        notification: {
          title,
          body: content,
        },
        topic: String(topic),
        data: {
          category: String(notify.page),
          type: String(notify.page),
        },
      };

      console.log(topic);
     try {
       const response = await admin.messaging().send(payload);
       console.log(`✅ Notification sent to topic [${topic}] | Message ID: ${response}`);
     } catch (error) {
       console.error(`❌ Error sending notification to topic [${topic}]:`, error);
     }

    }
  }
);

export const followUpReminder = onSchedule('every 5 minutes', async () => {
  const now = DateTime.now().setZone('Asia/Kolkata');

  const db = admin.firestore();
  const subscriptionsSnap = await db.collection('subscription').get();

  console.log(`🕒 Now (IST): ${now.toFormat("yyyy-MM-dd HH:mm:ss")}`);

  for (const companyDoc of subscriptionsSnap.docs) {
    const company = companyDoc.id;
    console.log(`🏢 Checking company: ${company}`);

    const enquiriesSnap = await db.collection(`subscription/${company}/enquiry`).get();

    for (const enquiryDoc of enquiriesSnap.docs) {
      const enquiry = enquiryDoc.data();
      const docId = enquiryDoc.id;

      if (!enquiry.follow_up_date || !enquiry.follow_up_time || !enquiry.user_uid) {
        console.log(`⚠️ Skipped enquiry ${docId} (missing date/time/user)`);
        continue;
      }

      let followUpDateTime = DateTime
        .fromJSDate(enquiry.follow_up_date.toDate())
        .setZone('Asia/Kolkata');

      const [timeStr, modifier] = enquiry.follow_up_time.split(' ');
      let [hours, minutes] = timeStr.split(':').map(Number);

      if (modifier === 'PM' && hours !== 12) hours += 12;
      if (modifier === 'AM' && hours === 12) hours = 0;

      followUpDateTime = followUpDateTime.set({
        hour: hours,
        minute: minutes,
        second: 0,
        millisecond: 0,
      });

      const diffInMinutes = followUpDateTime.diff(now, 'minutes').minutes;

      console.log(
        `📄 Enquiry: ${docId} | Follow-up at: ${followUpDateTime.toFormat("yyyy-MM-dd HH:mm")} | User: ${enquiry.user_uid} | Diff: ${Math.round(diffInMinutes)} min`
      );

      if ( diffInMinutes <= 60) {
        const uniqueKey = `${followUpDateTime.toISODate()}_${hours}:${minutes}`;

        const logSnap = await db
          .collection(`subscription/${company}/notification_logs`)
          .where('followup_date_time', '==', uniqueKey)
          .where('user_uid', '==', enquiry.user_uid)
          .limit(1)
          .get();

        if (logSnap.empty) {
          const messageBody = `Upcoming follow-up with ${enquiry.name} at today ${enquiry.follow_up_time}`;

          // 📲 Send notification
          await db.collection(`subscription/${company}/AppNotification`).add({
            msg: messageBody,
            page: 'Followup',
            timestamp: admin.firestore.Timestamp.now(),
            title: 'Followup',
            topic: enquiry.user_uid,
            user_uid: enquiry.user_uid,
            enquiryId: docId,
            deletedList: [],
            seenList: [],
          });

          // 📝 Log it
          await db.collection(`subscription/${company}/notification_logs`).add({
            sent_at: admin.firestore.Timestamp.now(),
            followup_date_time: uniqueKey,
            followup_actual: followUpDateTime.toJSDate(),
            user_uid: enquiry.user_uid,
            enquiry_id: docId,
            company_id: company,
          });

          console.log(`📬 Notification sent & logged for: ${docId} | Key: ${uniqueKey}`);
        } else {
          console.log(`🛑 Notification already sent for ${docId} | Key: ${uniqueKey}`);
        }
      } else {
        console.log(`⏳ Enquiry ${docId} not in window (diff = ${Math.round(diffInMinutes)} mins)`);
      }
    }
  }

  console.log(`✅ Completed follow-up scan at ${now.toFormat("HH:mm:ss")}`);
});


// export const followUpReminder = onSchedule('every 5 minutes', async () => {
//   const now = DateTime.now().setZone('Asia/Kolkata');
//
//   const windowStart = now.plus({ minutes: 57.5 });
//   const windowEnd = now.plus({ minutes: 62.5 });
//
//   console.log(`🕒 Now (IST): ${now.toFormat("yyyy-MM-dd HH:mm:ss")}`);
//   console.log(`🔍 Window Start: ${windowStart.toFormat("HH:mm:ss")}, Window End: ${windowEnd.toFormat("HH:mm:ss")}`);
//
//   const db = admin.firestore();
//   const subscriptionsSnap = await db.collection('subscription').get();
//
//   for (const companyDoc of subscriptionsSnap.docs) {
//     const company = companyDoc.id;
//     console.log(`🏢 Checking company: ${company}`);
//
//     const enquiriesSnap = await db.collection(`subscription/${company}/enquiry`).get();
//
//     for (const enquiryDoc of enquiriesSnap.docs) {
//       const enquiry = enquiryDoc.data();
//       const docId = enquiryDoc.id;
//
//       if (!enquiry.follow_up_date || !enquiry.follow_up_time || !enquiry.user_uid) {
//         console.log(`⚠️ Skipped enquiry ${docId} (missing date/time/user)`);
//         continue;
//       }
//
//       let followUpDateTime = DateTime
//         .fromJSDate(enquiry.follow_up_date.toDate())
//         .setZone('Asia/Kolkata');
//
//       const [timeStr, modifier] = enquiry.follow_up_time.split(' ');
//       let [hours, minutes] = timeStr.split(':').map(Number);
//
//       if (modifier === 'PM' && hours !== 12) hours += 12;
//       if (modifier === 'AM' && hours === 12) hours = 0;
//
//       followUpDateTime = followUpDateTime.set({ hour: hours, minute: minutes, second: 0, millisecond: 0 });
//
//       console.log(`📄 Enquiry: ${docId} | Follow-up at: ${followUpDateTime.toFormat("yyyy-MM-dd HH:mm")} | User: ${enquiry.user_uid}`);
//
//       if (followUpDateTime >= windowStart && followUpDateTime <= windowEnd) {
//         console.log(`✅ Enquiry ${docId} is within time window`);
//
//         const uniqueKey = `${followUpDateTime.toISODate()}_${hours}:${minutes}`;
//
//         const logSnap = await db
//           .collection(`subscription/${company}/notification_logs`)
//           .where('followup_date_time', '==', uniqueKey)
//           .where('user_uid', '==', enquiry.user_uid)
//           .limit(1)
//           .get();
//
//         console.log(logSnap)
//
//         if (logSnap.empty) {
//           console.log(`🚀 Sending notification to ${enquiry.user_uid} for enquiry ${docId}`);
//
//           const messageBody = `Upcoming follow-up with ${enquiry.name} at ${enquiry.follow_up_time}`;
//
//           await db.collection(`subscription/${company}/AppNotification`).add({
//             msg: messageBody,
//             page: 'Followup',
//             timestamp: admin.firestore.Timestamp.now(),
//             title: 'Followup',
//             topic: enquiry.user_uid,
//             user_uid: enquiry.user_uid,
//             enquiryId: docId,
//             deletedList: [],
//             seenList: [],
//           });
//
//           await db.collection(`subscription/${company}/notification_logs`).add({
//             sent_at: admin.firestore.Timestamp.now(),
//             followup_date_time: uniqueKey,
//             followup_actual: followUpDateTime.toJSDate(),
//             user_uid: enquiry.user_uid,
//             enquiry_id: docId,
//             company_id: company,
//           });
//
//           console.log(`📬 Notification logged and sent for: ${docId} | Key: ${uniqueKey}`);
//         } else {
//           console.log(`🛑 Notification already sent for ${docId} | Key: ${uniqueKey}`);
//         }
//       } else {
//         console.log(`⏳ Enquiry ${docId} is outside window (${followUpDateTime.toFormat("HH:mm")})`);
//       }
//     }
//   }
//
//   console.log(`✅ Completed follow-up scan at ${now.toFormat("yyyy-MM-dd HH:mm:ss")}`);
// });

export const createUserAccount = functions.https.onRequest(async (req: Request, res: Response) => {
  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }

  const { email, password } = req.body;

  if (!email || !password) {
    res.status(400).json({ error: 'Missing email or password' });
    return;
  }

  try {
    const userRecord = await admin.auth().createUser({
      email,
      password,
    });

    res.status(200).json({
      uid: userRecord.uid,
      email: userRecord.email,
      message: 'User created successfully',
    });
  } catch (error: any) {
    console.error('Error creating user:', error);
    res.status(500).json({ error: error.message });
  }
});

export const updateUserPasswordAndFirestore = functions.https.onRequest(async (req: Request, res: Response) => {
  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }

  const { email, newPassword, company } = req.body;
  const db = admin.firestore();

  if (!email || !newPassword || !company) {
    res.status(400).json({ error: 'Missing required fields: email, newPassword, or company' });
    return;
  }

  try {
    // Get UserRecord to access uid
    const userRecord = await admin.auth().getUserByEmail(email);
    const userId = userRecord.uid;

    // Update password in Auth
    await admin.auth().updateUser(userId, {
      password: newPassword,
    });

    // Update password field in Firestore
    const userDocRef = db.doc(`subscription/${company}/users/${userId}`);
    await userDocRef.update({
      password: newPassword,
    });

    res.status(200).json({
      uid: userId,
      message: 'Password updated successfully in Auth and Firestore',
    });
  } catch (error: any) {
    console.error('Error updating password:', error);
    res.status(500).json({ error: error.message });
  }
});