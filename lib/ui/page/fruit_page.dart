import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit/app/locale/app_localizations.dart';
import 'package:fruit/bloc/fruit_bloc.dart';
import 'package:fruit/model/fruit.dart';
import 'package:fruit/ui/widget/fruit_list_item_widget.dart';
import 'package:fruit/ui/widget/fruit_preview_widget.dart';
import 'package:intl/intl.dart';

/// author: febri.arianto@bukalapak.com
/// date: 2022-04-23

class FruitPageRoute extends MaterialPageRoute {
  FruitPageRoute({
    required FruitBloc bloc,
  }) : super(
          builder: (context) => BlocProvider(
            create: (context) => bloc,
            child: const FruitPage(),
          ),
        );
}

class FruitPage extends StatefulWidget {
  const FruitPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FruitPageState();
}

class FruitPageState extends State<FruitPage> {
  late AppLocalizations _locale;
  late NumberFormat _numberFormatter;

  @override
  void initState() {
    context.read<FruitBloc>().add(FetchItems());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _locale = AppLocalizations.of(context);
    _numberFormatter = NumberFormat(_locale.currencyFormat);
    return Scaffold(
      appBar: AppBar(
        title: Text(_locale.title),
      ),
      body: BlocConsumer<FruitBloc, FruitState>(
        listener: (context, state) {
          if (state is FetchFailed) {
            _showError(_locale.errorConnection);
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return _showLoading();
          } else if (state is FetchSuccess) {
            return _showList(state.items);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _showLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _showList(List<Fruit> items) {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.grey,
          );
        },
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return FruitListItemWidget(
            name: item.name,
            price: _locale.total(_numberFormatter.format(item.price)),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return FruitPreviewWidget(
                    imageUrl: item.image,
                    textButton: _locale.showQuantity,
                    onButtonPressed: () {
                      _showDialogFruit(item);
                    },
                  );
                },
              );
            },
          );
        });
  }

  void _showDialogFruit(Fruit fruit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_locale.title),
          content: Text(_locale.totalIs(fruit.name, '${fruit.quantity}')),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_locale.cancel),
            )
          ],
        );
      },
    );
  }
}
