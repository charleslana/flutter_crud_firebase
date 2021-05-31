import 'package:flutter_crud/models/user.dart';

const DUMMY_USERS = {
  '1': const User(
      id: '1',
      name: 'João',
      email: 'joao@example.com',
      avatarUrl: 'https://image.flaticon.com/icons/png/512/147/147144.png'),
  '2': const User(
      id: '2',
      name: 'Maria',
      email: 'maria@example.com',
      avatarUrl: 'https://image.flaticon.com/icons/png/512/194/194938.png'),
  '3': const User(
      id: '3',
      name: 'Batman',
      email: 'batman@example.com',
      avatarUrl:
          'https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/batman_hero_avatar_comics-512.png'),
  '4': const User(
      id: '4', name: 'User', email: 'user@example.com', avatarUrl: ''),
};
