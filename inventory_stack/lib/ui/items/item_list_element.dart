import 'package:flutter/cupertino.dart';
import 'package:inventory_stack/core/logic/migration/migration_bloc.dart';
import 'package:inventory_stack/core/models/item.dart';
import 'package:inventory_stack/core/models/migrations.dart';
import 'package:inventory_stack/ui/components/divider.dart';
import 'package:inventory_stack/ui/components/icon_duotone.dart';
import 'package:inventory_stack/ui/items/item_detail.dart';
import 'package:inventory_stack/ui/migration/distanation/destanation.dart';
import 'package:inventory_stack/utils/icons.dart';
import 'package:provider/src/provider.dart';

class ItemsListElement extends StatefulWidget {
  final bool isMigratory;
  const ItemsListElement(
      {Key? key, required this.data, this.isMigratory = false})
      : super(key: key);

  final ItemData data;

  @override
  _ItemsListElementState createState() => _ItemsListElementState();
}

class _ItemsListElementState extends State<ItemsListElement> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, minWidth: 300),
          child: GestureDetector(
            onTap: () {
              if (!widget.isMigratory) {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => ItemDetailPage(
                          data: widget.data,
                        )));
              }
            },
            child: Container(
              height: 105,
              color: CupertinoTheme.of(context).barBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: IconDuotone(
                                icon: widget.data.type?.icon,
                              ) //DeviceTypeList.fromInt(widget.data.type).icon,
                              ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          widget.data.name.length > 24
                                              ? widget.data.name
                                                      .substring(0, 23) +
                                                  "..."
                                              : widget.data.name,
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .textStyle),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      if (widget.data.currentPlaceUuid !=
                                          widget.data.rootPlaceUuid)
                                        MigrationIcons.alert,
                                    ],
                                  ),
                                  if (widget.data.description != null)
                                    Text(
                                      widget.data.description!
                                          .substring(
                                              0,
                                              widget.data.description!.length >
                                                      51
                                                  ? 50
                                                  : widget
                                                      .data.description?.length)
                                          .replaceAll('\n', " / "),
                                      style: CupertinoTheme.of(context)
                                          .textTheme
                                          .tabLabelTextStyle,
                                    ),
                                  const Spacer(),
                                  Text(
                                    "Гимназия 1 ИНВ №${widget.data.internalNumber}",
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .tabLabelTextStyle,
                                  ),
                                  Text(
                                    "Местоположение: ${widget.data.currentPlace?.name}",
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .tabLabelTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (!widget.isMigratory)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                  height: 100,
                                  child: CupertinoButton(
                                    child: MigrationIcons.right,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  ItemDetailPage(
                                                    data: widget.data,
                                                  )));
                                    },
                                  )),
                            ),
                          if (widget.isMigratory)
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CupertinoButton(
                                      child: Text(
                                          widget.data.currentPlaceUuid !=
                                                  widget.data.rootPlaceUuid
                                              ? "Вернуть"
                                              : "Переместить"),
                                      onPressed: () {
                                        if (widget.data.currentPlaceUuid != widget.data.rootPlaceUuid) {
                                          context.read<MigrationBloc>().add(MigrationCreateEvent(MigrationsData(
                                                    itemUuid: widget.data.uuid,
                                                    fromUuid: widget.data.currentPlaceUuid,
                                                    toUuid: widget.data.rootPlaceUuid
                                                  )));
                                        } else {
                                          Navigator.of(context)
                                              .push(CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const DestinationPage(
                                                          previus: "Миграции")))
                                              .then((value) {
                                                if(value!= null){
                                                  String destanation = value as String;
                                                  context.read<MigrationBloc>().add(MigrationCreateEvent(MigrationsData(
                                                    itemUuid: widget.data.uuid,
                                                    fromUuid: widget.data.currentPlaceUuid,
                                                    toUuid: destanation
                                                  )));
                                                }
                                          });
                                        }
                                      })
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const CustomDivider()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
