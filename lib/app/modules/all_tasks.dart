import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/todos_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({super.key});

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  final service = IsarServices();

  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  void initState() {
    getCountTodos();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  getCountTodos() async {
    final countTotal = await service.getCountTotalTodos();
    final countDone = await service.getCountDoneTodos();
    setState(() {
      countTotalTodos = countTotal;
      countDoneTodos = countDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      width: Get.size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 10, bottom: 5, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'allTasks'.tr,
                      style: context.theme.textTheme.titleLarge?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '($countDoneTodos/$countTotalTodos) ${'completed'.tr}',
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Switch(
                  trackColor: service.trackColor,
                  thumbIcon: service.thumbIcon,
                  value: service.toggleValue.value,
                  onChanged: (value) {
                    setState(() {
                      service.toggleValue.value = value;
                    });
                  },
                ),
              ],
            ),
          ),
          TodosList(
            calendare: false,
            allTask: true,
            toggle: service.toggleValue.value,
            set: () {
              getCountTodos();
            },
          ),
        ],
      ),
    );
  }
}