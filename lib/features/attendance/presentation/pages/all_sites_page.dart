import 'dart:async';
import 'dart:developer';

import 'package:attendence_system_dashboard/data/apis.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/add_stite_page.dart';
import 'package:flutter/material.dart';

class AllSitesPage extends StatefulWidget {
  const AllSitesPage({super.key});

  @override
  State<AllSitesPage> createState() => _AllSitesPageState();
}

class _AllSitesPageState extends State<AllSitesPage> {
  List<Map<String, dynamic>> sites = [];
  TextEditingController searchController = TextEditingController();
  Timer? debounce;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchSites('');
  }

  void _searchSites(String keyword) {
    debounce?.cancel();
    setState(() => isLoading = true);
    debounce = Timer(const Duration(milliseconds: 400), () async {
      final results = await Apis.availableSties(search: keyword);
      setState(() {
        sites = results
                ?.map(
                  (e) => e.toJson(),
                )
                .toList() ??
            [];
        isLoading = false;
      });
    });
  }

  void _confirmDelete(String siteId, String siteName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Site'),
        content: Text('Are you sure you want to delete "$siteName"?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: const Text('Delete'),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await Apis.deleteSite(siteId);
              if (success == true) {
                setState(() {
                  sites.removeWhere((site) => site['id'].toString() == siteId);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Site "$siteName" deleted successfully'),
                    backgroundColor: Colors.red.shade600,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete site "$siteName"'),
                    backgroundColor: Colors.red.shade400,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _onAddSite,
          label: Text(
            'Add Site',
          ),
          icon: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: _searchSites,
                    decoration: InputDecoration(
                      hintText: 'Search sites...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      suffixIcon: searchController.text.isNotEmpty
                          ? (isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.black),
                                  onPressed: () {
                                    searchController.clear();
                                    _searchSites('');
                                  },
                                ))
                          : null,
                    ),
                  )),
              sites.isEmpty
                  ? const Expanded(child: Center(child: Text('No sites found')))
                  : Expanded(
                      child: ListView.separated(
                        itemCount: sites.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final site = sites[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(site['name'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87)),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          color: Colors.grey[700]),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Latitude: ${site['location']['lat']}, Longitude: ${site['location']['lng']}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.circle,
                                          size: 16, color: Colors.grey[700]),
                                      SizedBox(width: 8),
                                      Text('Radius: ${site['radius']} meters',
                                          style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: () => _editSite(site),
                                        icon: const Icon(Icons.edit, size: 18),
                                        label: const Text("Edit"),
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      ElevatedButton.icon(
                                        onPressed: () => _confirmDelete(
                                            site['id'].toString(),
                                            site['name']),
                                        icon: const Icon(Icons.delete_outline,
                                            size: 18),
                                        label: const Text("Delete"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade600,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ));
  }

  void _editSite(Map<String, dynamic> site) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddSitePage(site: site,),
    ));
    log('$result', name: 'REFRESH_SITE');
    if (result is bool && result == true) {
      _searchSites('');
    }
  }

  void _onAddSite() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AddSitePage(),
    ));
    if (result is bool && result == true) {
      _searchSites('');
    }
  }
}
