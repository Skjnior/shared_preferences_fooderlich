import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class MyRecipesList extends StatefulWidget {
  const MyRecipesList({Key? key}) : super(key: key);

  @override
  _MyRecipesListState createState() => _MyRecipesListState();
}

class _MyRecipesListState extends State<MyRecipesList> {
  // TODO 1
  List<String> recipes = [];

  // TODO 2
  @override
  void initState() {
    super.initState();
    recipes = <String>[];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildRecipeList(context),
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    // TODO 3
    return ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          // TODO 4
          return SizedBox(
            height: 100,
            child: Slidable(
              // Utilisation correcte de ActionPane
              endActionPane: ActionPane(
                motion: const DrawerMotion(), // SlidableDrawerActionPane est obsolète
                children: [
                  SlidableAction(
                    label: 'Delete', // Remplacement de 'caption' par 'label'
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    icon: Icons.delete, // Utilisation de 'icon' directement au lieu de 'iconWidget'
                    onPressed: (context) {
                      // TODO 7 : Ajouter ici la fonction pour supprimer
                    },
                  ),
                ],
              ),
              startActionPane: ActionPane(
                motion: const DrawerMotion(), // SlidableDrawerActionPane est obsolète
                children: [
                  SlidableAction(
                    label: 'Delete', // Remplacement de 'caption' par 'label'
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    icon: Icons.delete, // Utilisation de 'icon' directement au lieu de 'iconWidget'
                    onPressed: (context) {
                      // TODO 8 : Ajouter ici la fonction pour supprimer
                    },
                  ),
                ],
              ),
              child: Card(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.white,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CachedNetworkImage(
                        // TODO 5 : Correction de l'URL
                        imageUrl: 'http://www.seriouseats.com/recipes/2011/12/chicken-vesuvio-recipe.html',
                        height: 120,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                      // TODO 6
                      title: const Text('Chicken Vesuvio'),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
    // TODO 9
  }
}
