const httpServer = require('http').createServer()
const socketIO = require('socket.io')(httpServer)
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const {
  time,
  timeStamp
} = require('console');
const {
  emit
} = require('process');

let roomIdForChat;

const productschema = new mongoose.Schema({
  user: String,
  mobile: Number,
  password: String,
  uid: String
});

const roomSchema = new mongoose.Schema({
  user1: String,
  user2: String,
  roomId: String,
});

const messageSchema = new mongoose.Schema({
  // from: String,
  // to: String,
  // seen: Boolean,
  // massage: String,
  // time: Number

  // bool seen;
  // String username;
  // String sentAt;
  // String to;
  // String message;

  seen: Boolean,
  username: String,
  to: String,
  message: String,

}, {
  timestamps: true
})

// randomString genrator

function makeRoomId(length) {
  var result = '';
  var characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  var charactersLength = characters.length;
  for (var i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() *
      charactersLength));
  }
  return result;
}

// createUser()
const createUser = async (Data) => {
  const productmodel = await mongoose.model('users', productschema);
  var obj = JSON.parse((Data));
  var keys = Object.keys(obj);
  try {
    var oldUser = await productmodel.findOne({
      'mobile': obj[keys[2]]
    });
    if (oldUser != null) {
      socketIO.emit('err', {
        "err": "user is alrady exist"
      });
    } else {
      encryptedPassword = await bcrypt.hash(obj[keys[1]], 10);
      let data = await productmodel.create({
        user: obj[keys[0]],
        mobile: obj[keys[2]],
        password: encryptedPassword,
        uid: obj[keys[3]],
      });
      console.log('this is create user data', data);

      socketIO.emit('Done', {
        "Done": "Successfully created"
      })
    }
  } catch (err) {
    console.log(err);
  }
}

// login User
const signIn = async (Data) => {
  const productmodel = await mongoose.model('users', productschema);
  var obj = JSON.parse((Data));
  var keys = Object.keys(obj);
  try {
    var user = await productmodel.findOne({
      'user': obj[keys[0]],
    });
    if (user != null) {
      if ((await bcrypt.compare(obj[keys[1]], user.password)) && user.user == obj[keys[0]]) {
        socketIO.emit('Done', {
          "Done": "Successfully LogedIn",
          "user": user['user'],
          "mobile": user['mobile'],
          "uid": user[uid]
        });


      } else {
        socketIO.emit('invalid', {
          "invalid": "UserId or password is incorrect"
        });
      }

    } else {
      socketIO.emit('err', {
        "err": "User dose not exist"
      });
    }
  } catch (err) {
    console.log(err);
  }
  var obj = JSON.parse((Data));
  var keys = Object.keys(obj);
  // for (var i = 0; i < keys.length; i++) {
  // console.log(obj[keys[0]]);
  // }


  let data = await productmodel.findOne({
    'user': obj[keys[0]]
  });
}

// allusers();

const allusers = async () => {
  const productmodel = await mongoose.model('users', productschema);
  try {
    var user = await productmodel.find();
    socketIO.emit('getUsers', user);

  } catch (err) {
    console.log(err, 'error will be occurd');
  }
}

const findRoom = async (Data) => {
  const roomModel = await mongoose.model('chatrooms', roomSchema);
  
  var obj = JSON.parse((Data));
  var keys = Object.keys(obj);
  try {
    var room = await roomModel.find({
      $or: [{
          user1: obj[keys[0]],
          user2: obj[keys[1]],
        },
        {
          user1: obj[keys[1]],
          user2: obj[keys[0]],
        }
      ]
    })

    if (room.length == 0) {
      console.log('room is null');
      try {

        RoomId = await makeRoomId(30);

        console.log('========', RoomId, '=====');
        var workDone = await roomModel.create({
          user1: obj[keys[0]],
          user2: obj[keys[1]],
          roomId: RoomId
        })
        // console.log('workdome: ', workDone);
        roomIdForChat = RoomId;
        socketIO.emit('roomID', (RoomId));
        // GotoRoom(RoomId);
      } catch (err) {
        console.log('error is this : ', err);
      }

    } else {
      // console.log('thid is else');
      console.log(room[0]['roomId'], 'this is room id');
      var roomId = room[0]['roomId'];
      roomIdForChat = roomId;
      socketIO.emit('roomID', (roomId));
      // GotoRoom(roomId);


    }

  } catch (err) {
    console.log('this is err : ', err);
  }

}

// const GotoRoom = async (RoomData) => {
const GotoRoom = async (roomData) => {
  // console.log('goto room', roomData);
  var obj = JSON.parse((roomData));
  var keys = Object.keys(obj);
  // console.log(obj[keys[0]]);
  roomId = obj[keys[0]];
  // console.log('this is ROOMdaTA: ', roomId);
  // console.log('gotoroom is ');
  const chatGetModel = await mongoose.model(roomId, messageSchema);
  // console.log('this is cahtmodel');
  let chats = await chatGetModel.find();
  socketIO.emit('chatData', chats);
  // console.log(chats);


}

// massage sending

const message = async (messageData) => {
  const massageModel = await mongoose.model(roomIdForChat, messageSchema);
  let data = await massageModel.create(messageData);



}





socketIO.on('connection', async function (client) {
  console.log('Connected...', client.id);
  //listens when a user is disconnected from the server
  let mon = await mongoose.connect("Here you pest you mongodb database url");
  //  console.log("mon",mon);
  client.on('disconnect', function () {
    console.log('Disconnected...', client.id);
    socketIO.emit('disconnect1', client.id);
  })

  //listens when there's an error detected and logs the error on the console
  client.on('error', function (err) {
    console.log('Error detected', client.id);
    console.log(err);
  })

  // login
  client.on('signIn', async function name2(data) {
    console.log(data);
    signIn(data);
    socketIO.emit('signIn', data);
  })

  // signUP
  client.on('signUp', async function name1(data) {
    console.log('this is on ', data);
    await createUser(data)
    socketIO.emit('signUp', data);
  })

  client.on('allUsers', async function name1() {
    await allusers();
    socketIO.emit('allUsers');
  })

  client.on('findRoom', async function name1(data) {
    await findRoom(data);
    socketIO.emit('findRoom');
  })

  client.on('chatRoom', async function chatRoom(data) {
    console.log('this is chatroom on');
    await GotoRoom(data);
    socketIO.emit('chatRoom');
  })

  client.on('message', async function chatRoom(data) {
    console.log('this is chatroom on');
    console.log(data);
    await message(data);


    socketIO.emit('message');
  })
})





var port = process.env.PORT || 3000;
httpServer.listen(port, function (err) {
  if (err) console.log(err);
  console.log('Listening on port', port);
});