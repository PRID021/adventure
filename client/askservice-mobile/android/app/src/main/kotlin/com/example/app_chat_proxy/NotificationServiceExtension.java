package com.example.app_chat_proxy;

import static android.app.Notification.DEFAULT_VIBRATE;


import static androidx.core.app.NotificationCompat.PRIORITY_MAX;

import com.onesignal.notifications.IActionButton;
import com.onesignal.notifications.IDisplayableMutableNotification;
import com.onesignal.notifications.INotificationReceivedEvent;
import com.onesignal.notifications.INotificationServiceExtension;

public class NotificationServiceExtension implements INotificationServiceExtension {

    @Override
    public void onNotificationReceived(INotificationReceivedEvent event) {
        IDisplayableMutableNotification notification = event.getNotification();

        if (notification.getActionButtons() != null) {
            for (IActionButton button : notification.getActionButtons()) {
                // you can modify your action buttons here
            }
        }

        // this is an example of how to modify the notification by changing the background color to blue
        notification.setExtender((builder) -> {
            builder.setColor(0xffffff);
            builder.setDefaults(DEFAULT_VIBRATE);
            builder.setPriority(PRIORITY_MAX);
            return builder;
        });
        notification.display();

    }
}