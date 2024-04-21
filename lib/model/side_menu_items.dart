import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenuController extends GetxController {
  RxInt hoveredIndex = (-1).obs;
  RxList<bool> isClickedList = <bool>[
    false,
    false,
    false,
    false,
    false,
  ].obs;
  RxInt selectedIndex = (-1).obs;

  void onHover(int index) {
    hoveredIndex.value = index;
  }

  void onExit() {
    hoveredIndex.value = -1;
  }

  void onClick(int index) {
    isClickedList[index] = true;

    if (selectedIndex.value != -1) {
      isClickedList[selectedIndex.value] = false;
    }
    selectedIndex.value = index;
  }

  void resetClick(int index) {
    isClickedList[index] = false;
  }
}

class SideMenuItems extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;
  final int index;

  const SideMenuItems({
    super.key,
    required this.title,
    required this.icon,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final SideMenuController controller = Get.put(SideMenuController());

    return Obx(() {
      final bool isHovered = controller.hoveredIndex.value == index;
      final bool isClicked = controller.isClickedList[index];

      return InkWell(
        onTap: () {
          controller.onClick(index);
          onTap?.call();
        },
        onTapCancel: () => controller.resetClick(index),
        child: MouseRegion(
          onEnter: (_) => controller.onHover(index),
          onExit: (_) => controller.onExit(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              gradient: isClicked
                  ? LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.5),
                        Colors.blue.withOpacity(0.2)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: const TextStyle(
                    // fontSize: 16,
                    // color: Colors.grey[700],
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
