import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../cubit/home/home_cubit.dart';
import '../user_controller.dart';

class HomePage extends StatelessWidget {
  final searchController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: Column(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search by name, phone or city',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  BlocProvider.of<HomeCubit>(context)
                      .filterUsers(searchController.text);
                },
              );
            },
          ),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final displayedUsers =
                  BlocProvider.of<HomeCubit>(context).displayedUsers;
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: displayedUsers.length + 1,
                  itemBuilder: (context, index) {
                    if (index == displayedUsers.length) {
                      return ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<HomeCubit>(context).loadMore();
                        },
                        child: const Text('Load More'),
                      );
                    }
                    final user = displayedUsers[index];
                    return ListTile(
                      leading: Image.network(
                        user.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(user.name),
                      subtitle: Text('${user.city}\n${user.phoneNumber}'),
                      trailing: Text(
                        user.isHighStock ? 'High' : 'Low',
                        style: TextStyle(
                          color: user.isHighStock ? Colors.green : Colors.red,
                        ),
                      ),
                      onTap: () => _showEditDialog(context, user),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, User user) {
    final TextEditingController _rupeeController =
        TextEditingController(text: user.rupee.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Rupee for ${user.name}'),
          content: TextField(
            controller: _rupeeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Rupee',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final int? newRupee = int.tryParse(_rupeeController.text);
                if (newRupee != null && newRupee >= 0 && newRupee <= 100) {
                  BlocProvider.of<HomeCubit>(context)
                      .updateRupee(user, newRupee);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Please enter a valid Rupee value between 0 and 100')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
