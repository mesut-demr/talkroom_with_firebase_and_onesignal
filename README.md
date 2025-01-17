# TalkRoom with Firebase and OneSignal

![Flutter Logo](https://img.icons8.com/?size=48&id=7I3BjCqe9rjG&format=png) 3.27.1 ![Firebase Logo](https://img.icons8.com/?size=48&id=62452&format=png)  ![OneSignal Logo](https://img.icons8.com/?size=48&id=LEgCLBzQop5Z&format=png) 

A simple room messaging app created using Flutter and Dart.

**Requesting notification permission from users when entering the app for OneSignal.**
<br/>
<img src="https://github.com/user-attachments/assets/9ecc1e06-b039-49de-b4bf-875d1e7c158a"  width="320">

**Users can register with a normal email and password or register using Google Authentication when entering the app.**
<br/>
<img src="https://github.com/user-attachments/assets/d12df783-84b4-4516-8e6a-8623767e1d96"  width="320"> <img src="https://github.com/user-attachments/assets/67584f26-b9cb-4cf8-a8a9-08a4a4e942c0"  width="320">

**The login page for users.**
<br/>
<img src="https://github.com/user-attachments/assets/541447b4-0a53-4bed-8e1b-60059698bb94"  width="320">

**Users can create rooms.**
<br/>
<img src="https://github.com/user-attachments/assets/3fd2659b-5977-41f7-91ba-afc82dec5743"  width="320">

**Users can comment in rooms, and other users can like these comments. The comment owner will receive a notification.**
<br/>
<img src="https://github.com/user-attachments/assets/9ce284aa-861d-4ba0-ba9f-6738c50817dd"  width="320"> <img src="https://github.com/user-attachments/assets/4118803b-1177-4d23-b36d-7db6ba058ed1"  width="320">

**Profile Page**
<br/>
<img src="https://github.com/user-attachments/assets/6c579653-4bbe-4ae0-a45b-0e2eaade2301"  width="320">

# App Architecture

- &#9745; The **BloC (cubit)** structure was used to manage the state.
- &#9745; The **http** package was used to send notifications.
- &#9745; The **equatable** package was used to compare the objects.
- &#9745; The **go_router** package was used for navigation in the app.

## Brief Summary

This app provides a platform where users can easily sign up and log in, and interact in various rooms. With Firebase and OneSignal integrations, users can securely log in using either email & password or Google Authentication.
After logging in, users can create different rooms and chat with other users in these rooms. Whenever a user likes someone else's message, the liker receives an instant notification. This provides an interactive experience where users can actively respond to each other's content.
Additionally, users can view their personal information on their profile page.
The core logic of the app is that users can comment on different content, like each other's messages, and receive notifications through these interactions, creating a dynamic experience.
