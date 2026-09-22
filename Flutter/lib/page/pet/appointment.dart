// lib/page/pet/appointment.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/user-service.dart';
import '../../services/shop-service.dart';
import '../../services/appointment-service.dart';
import '../../core/network/api-exception.dart';

import '../../component/appointment/common.dart';
import '../../component/appointment/service.dart';
import '../../component/appointment/addons.dart';
import '../../component/appointment/groomer.dart';
import '../../component/appointment/time.dart';
import '../../component/appointment/confirm.dart';

import '../shop/payment.dart';

import '../../view-models/pet.dart';
import '../../view-models/shop.dart';
import '../../view-models/appointment.dart';
import '../../view-models/payment.dart';

enum AppointmentStage { service, addons, groomer, time, confirm }

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  AppointmentStage _stage = AppointmentStage.service;
  PetData? _selectedPet;
  List<PetData> _pets = [];
  ServiceData? _selectedService;
  double _servicePrice = 0;
  List<ServiceData> _services = [];
  ServiceData? _selectedStyling;
  ServiceData? _selectedSPA;
  List<ServiceData> _premiums = [];
  List<ServiceData> _selectedAddons = [];
  List<ServiceData> _addons = [];
  ShopData? _selectedShop;
  List<ShopData> _shops = [];
  GroomerData? _selectedGroomer;
  List<GroomerData> _groomers = [];
  DateTime? _selectedDate;
  List<AppointmentSlotData> _slots = [];
  AppointmentSlotData? _selectedSlot;
  String _notes = '';

  double get _subtotal {
    double total = _servicePrice;
    total += _selectedStyling?.price ?? 0;
    total += _selectedSPA?.price ?? 0;

    for (final addon in _selectedAddons) {
      total += addon.price;
    }

    total += _selectedGroomer?.price ?? 0;

    return total;
  }

  AppointmentStep get _progressStep {
    switch (_stage) {
      case AppointmentStage.service:
      case AppointmentStage.addons:
        return AppointmentStep.service;
      case AppointmentStage.groomer:
        return AppointmentStep.groomer;
      case AppointmentStage.time:
        return AppointmentStep.time;
      case AppointmentStage.confirm:
        return AppointmentStep.confirm;
    }
  }

  String get _title {
    switch (_stage) {
      case AppointmentStage.service:
        return 'Appointment';
      case AppointmentStage.addons:
        return 'Add-on Services';
      case AppointmentStage.groomer:
        return 'Choose Groomer';
      case AppointmentStage.time:
        return 'Appointment Time';
      case AppointmentStage.confirm:
        return 'Confirm Appointment';
    }
  }

  String get _buttonText {
    switch (_stage) {
      case AppointmentStage.service:
        return 'Next: Add-ons';
      case AppointmentStage.addons:
        return 'Next: Groomer';
      case AppointmentStage.groomer:
        return 'Next: Time';
      case AppointmentStage.time:
        return 'Next: Confirm';
      case AppointmentStage.confirm:
        return 'Confirm & Pay';
    }
  }

  void _next() {
    switch (_stage) {
      case AppointmentStage.service:
        if (_selectedService == null) {
          _showMessage('Please select a service');
          return;
        }

        setState(() {
          _stage = AppointmentStage.addons;
        });
        break;
      case AppointmentStage.addons:
        setState(() {
          _stage = AppointmentStage.groomer;
        });
        break;
      case AppointmentStage.groomer:
        if (_selectedShop == null) {
          _showMessage('Please select a store');
          return;
        }

        if (_selectedGroomer == null) {
          _showMessage('Please select a groomer');
          return;
        }

        setState(() {
          _stage = AppointmentStage.time;
        });

        break;
      case AppointmentStage.time:
        if (_selectedDate == null || _selectedSlot == null) {
          _showMessage('Please select a date and time');
          return;
        }

        setState(() {
          _stage = AppointmentStage.confirm;
        });
        break;
      case AppointmentStage.confirm:
        _submitAppointment();
        break;
    }
  }

  void _back() {
    switch (_stage) {
      case AppointmentStage.service:
        Navigator.pop(context);
        break;
      case AppointmentStage.addons:
        setState(() {
          _stage = AppointmentStage.service;
        });
        break;
      case AppointmentStage.groomer:
        setState(() {
          _stage = AppointmentStage.addons;
        });
        break;
      case AppointmentStage.time:
        _getAvailability(DateTime.now());
        setState(() {
          _stage = AppointmentStage.groomer;
        });
        break;
      case AppointmentStage.confirm:
        setState(() {
          _stage = AppointmentStage.time;
        });
        break;
    }
  }

  void _submitAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          type: PaymentSummaryType.appointment,
          appointment: PaymentAppointmentData(
            pet: _selectedPet!,
            service: _selectedService!,
            styling: _selectedStyling,
            spa: _selectedSPA,
            shop: _selectedShop!,
            groomer: _selectedGroomer!,
            slot: _selectedSlot!,
            notes: _notes,
            addons: _selectedAddons,
          ),
          amount: _subtotal,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildContent() {
    switch (_stage) {
      case AppointmentStage.service:
        return AppointmentServiceContent(
          selectedPet: _selectedPet,
          pets: _pets,
          selectedService: _selectedService,
          services: _services,
          onServiceChanged: (service) {
            setState(() {
              _selectedService = service;
              _servicePrice = service.price;
            });
          },
        );
      case AppointmentStage.addons:
        return AppointmentAddonsContent(
          selectedStyling: _selectedStyling,
          selectedSPA: _selectedSPA,
          premiums: _premiums,
          selectedAddons: _selectedAddons,
          addons: _addons,
          onChangedStyling: (styling) {
            setState(() {
              _selectedStyling = styling;
            });
          },
          onChangedSPA: (spa) {
            setState(() {
              _selectedSPA = spa;
            });
          },
          onChangedAddons: (addons) {
            setState(() {
              _selectedAddons = [...addons];
            });
          },
        );
      case AppointmentStage.groomer:
        return AppointmentGroomerContent(
          selectedShopId: _selectedShop?.id ?? 0,
          shops: _shops,
          onShopChanged: (shop) => _onShopChanged(shop),
          selectedGroomerId: _selectedGroomer?.id,
          groomers: _groomers,
          onGroomerChanged: (groomer) {
            setState(() {
              _selectedGroomer = groomer;
            });
          },
        );
      case AppointmentStage.time:
        return AppointmentTimeContent(
          selectedDate: _selectedDate,
          selectedSlot: _selectedSlot,
          slots: _slots,
          duration:
              (_selectedService?.duration ?? 0) +
              (_selectedStyling?.duration ?? 0) +
              (_selectedSPA?.duration ?? 0),
          closingTime: _selectedShop?.closingTime ?? '',
          onDateChanged: (date) {
            _getAvailability(date);
            setState(() {
              _selectedDate = date;
              _selectedSlot = null;
            });
          },
          onTimeChanged: (slot) {
            setState(() {
              _selectedSlot = slot;
            });
          },
        );
      case AppointmentStage.confirm:
        return AppointmentConfirmContent(
          pet: _selectedPet!,
          service: _selectedService!,
          styling: _selectedStyling,
          spa: _selectedSPA,
          shop: _selectedShop!,
          groomer: _selectedGroomer!,
          slot: _selectedSlot!,
          initialNotes: _notes,
          onNotesChanged: (value) {
            _notes = value;
          },
          selectedAddons: _selectedAddons,
          addons: _addons,
          onChangedAddons: (addons) {
            setState(() {
              _selectedAddons = [...addons];
            });
          },
        );
    }
  }

  @override
  void initState() {
    super.initState();

    _getPetList();
  }

  Future<void> _getPetList() async {
    try {
      final res = await UserService.instance.getPetList();
      final list = res.pets.map((item) => PetData.fromModel(item)).toList();

      final pet = list[0];
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('pet_id', pet.id);

      setState(() {
        _pets = list;
        _selectedPet = list[0];
      });

      _getServiceAndAddonList();
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _getServiceAndAddonList() async {
    try {
      final res = await AppointmentService.instance.getServiceAndAddonList();
      final services = res.services
          .map((item) => ServiceData.fromModel(item))
          .toList();
      final premiums = res.premiums
          .map((item) => ServiceData.fromModel(item))
          .toList();
      final addons = res.addons
          .map((item) => ServiceData.fromModel(item))
          .toList();
      setState(() {
        _services = services;
        _premiums = premiums;
        _addons = addons;
      });

      _getShopList();
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _getShopList() async {
    try {
      final res = await ShopService.instance.getShopList();
      final list = res.shops.map((item) => ShopData.fromModel(item)).toList();

      final shop = list[0];
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('shop_id', shop.id);

      setState(() {
        _shops = list;
        _selectedShop = shop;
      });

      _getGroomerList();
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _getGroomerList() async {
    try {
      final res = await AppointmentService.instance.getGroomerList();
      final list = res.groomers
          .map((item) => GroomerData.fromModel(item))
          .toList();

      setState(() {
        _groomers = list;
      });
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _onShopChanged(ShopData shop) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('shop_id', shop.id);

    setState(() {
      _selectedShop = shop;
      _selectedGroomer = null;
      _groomers = [];
      _selectedDate = null;
      _selectedSlot = null;
    });

    await _getGroomerList();
  }

  Future<void> _getAvailability(DateTime date) async {
    try {
      var ids = [_selectedService!.priceId];
      if (_selectedStyling != null) {
        ids.add(_selectedStyling!.priceId);
      }
      if (_selectedSPA != null) {
        ids.add(_selectedSPA!.priceId);
      }

      final res = await AppointmentService.instance.getAvailability(
        _selectedShop!.id,
        _selectedGroomer!.id,
        ids,
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      );
      final list = res.slots
          .map((item) => AppointmentSlotData.fromModel(item))
          .toList();

      setState(() {
        _slots = list;
      });
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFDFB),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppointmentHeader(title: _title, onBack: _back),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppointmentProgress(currentStep: _progressStep),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: KeyedSubtree(
                  key: ValueKey(_stage),
                  child: _buildContent(),
                ),
              ),
            ),
            AppointmentBottomBar(
              subtotal: _subtotal,
              duration:
                  (_selectedService?.duration ?? 0) +
                  (_selectedStyling?.duration ?? 0) +
                  (_selectedSPA?.duration ?? 0),
              buttonText: _buttonText,
              onViewDetails: () {
                debugPrint('View details');
              },
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }
}
