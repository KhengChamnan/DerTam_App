// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tourism_app/models/budget/expend.dart';
import 'package:tourism_app/models/trips/trips.dart';
import 'package:tourism_app/ui/widgets/dertam_textfield.dart';
import 'package:tourism_app/ui/providers/budget_provider.dart';
import 'package:tourism_app/ui/providers/trip_provider.dart';
import 'package:tourism_app/theme/theme.dart';

class AddExpenseScreen extends StatefulWidget {
  final String selectedCurrency;
  final double remainingBudget;
  final String budgetId;
  final String tripId;
  final Expense? expense; // Optional expense for editing
  final bool isEditing; // Flag to indicate edit mode

  const AddExpenseScreen({
    super.key,
    required this.selectedCurrency,
    required this.remainingBudget,
    required this.budgetId,
    required this.tripId,
    this.expense, // Optional parameter
    this.isEditing = false, // Default to add mode
  });

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  double _totalExpense = 0.0;
  bool _isLoading = false;
  Trip? _trip;
  int _selectedDayIndex = 0;
  DateTime _selectedDate = DateTime.now();
  double _availableBudgetForSelectedDay = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchTripData();
    
    // Initialize with default values
    _peopleController.text = "1"; // Default to 1 person
    
    // If editing, prefill form with expense data
    if (widget.isEditing && widget.expense != null) {
      // Set expense amount (divided by people count if needed)
      _expenseController.text = widget.expense!.amount.toString();
      _descriptionController.text = widget.expense!.description;
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
      
      // We're assuming amount is per person × peopleCount
      // If you store the people count, you'd need to set it here
      
      // Calculate total based on prefilled values
      _calculateTotalExpense();
    } else {
      _calculateTotalExpense();
    }
  }

  // Fetch trip data to get days
  Future<void> _fetchTripData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tripProvider = Provider.of<TripProvider>(context, listen: false);
      final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
      
      // Listen to the trip stream
      tripProvider.getTripByIdStream(widget.tripId).listen((trip) {
        if (trip != null && mounted) {
          setState(() {
            _trip = trip;
            
            // If editing, find the corresponding day index based on the expense date
            if (widget.isEditing && widget.expense != null && trip.days.isNotEmpty) {
              // Find the day index that matches the expense date
              final expenseDate = DateTime(
                widget.expense!.date.year, 
                widget.expense!.date.month, 
                widget.expense!.date.day
              );
              final tripStartDate = DateTime(
                trip.startDate.year, 
                trip.startDate.month, 
                trip.startDate.day
              );
              
              // Calculate days difference
              final difference = expenseDate.difference(tripStartDate).inDays;
              
              // Set day index if it's within the valid range
              if (difference >= 0 && difference < trip.days.length) {
                _selectedDayIndex = difference;
                _selectedDate = trip.startDate.add(Duration(days: _selectedDayIndex));
              }
            } else if (trip.days.isNotEmpty) {
              // Normal flow for adding new expense
              _selectedDate = trip.startDate.add(Duration(days: _selectedDayIndex));
            }
            
            // Update available budget for selected day
            if (budgetProvider.selectedBudget != null) {
              _updateAvailableBudget();
            }
          });
        }
      });
      
      // Start listening to budget updates
      budgetProvider.startListeningToBudget(widget.tripId);
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error fetching trip data: $e"),
            backgroundColor: DertamColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Update available budget based on selected day
  void _updateAvailableBudget() {
    if (_trip == null) return;
    
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    final budget = budgetProvider.selectedBudget;
    
    if (budget == null) return;
    
    setState(() {
      // Make sure we're using the actual daily budget from the budget object
      _availableBudgetForSelectedDay = budget.dailyBudget;
      
      // If daily budget is zero but total budget exists, calculate it
      if (_availableBudgetForSelectedDay <= 0 && budget.total > 0 && _trip!.days.isNotEmpty) {
        _availableBudgetForSelectedDay = budgetProvider.calculateDailyBudget(budget.total, _trip!.days.length);
        print("Fixed zero daily budget: $_availableBudgetForSelectedDay");
      }
      
      // Debug info - remove in production
      print("Daily budget set to: ${budget.dailyBudget}");
      print("Available budget set to: $_availableBudgetForSelectedDay");
      print("Total budget: ${budget.total}");
      print("Number of days: ${_trip!.days.length}");
    });
  }

  // Calculate total expense based on expense amount and number of people
  void _calculateTotalExpense() {
    double expenseAmount = double.tryParse(_expenseController.text) ?? 0.0;
    int peopleCount = int.tryParse(_peopleController.text) ?? 1;
    double newTotal = expenseAmount * peopleCount;

    if (newTotal != _totalExpense) {
      setState(() {
        _totalExpense = newTotal;
      });
    }
  }

  // Format day for dropdown display
  String _formatDayForDropdown(int dayIndex) {
    if (_trip == null) return "Day ${dayIndex + 1}";
    
    final date = _trip!.startDate.add(Duration(days: dayIndex));
    final today = DateTime.now();
    final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
    
    String formattedDate = "${DateFormat('EEE').format(date)} ${DateFormat('dd/MM').format(date)}";
    
    // Add "Today" label if it's today's date
    if (isToday) {
      formattedDate += " (Today)";
    }
    
    return formattedDate;
  }

  // Get the date status (Today, Future, Past)
  String _getDateStatus(DateTime date) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    
    if (checkDate.isAtSameMomentAs(todayDate)) {
      return "Today";
    } else if (checkDate.isAfter(todayDate)) {
      return "Future";
    } else {
      return "Past";
    }
  }

  // Add or update expense logic with validation
  Future<void> _addExpense() async {
    if (_expenseController.text.isEmpty || _peopleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all required fields."),
          backgroundColor: DertamColors.red,
        ),
      );
      return;
    }

    int peopleCount = int.tryParse(_peopleController.text) ?? 1;

    if (peopleCount < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Number of people must be at least 1."),
          backgroundColor: DertamColors.red,
        ),
      );
      return;
    }
    
    // Check if expense amount is valid
    if (_totalExpense <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid expense amount."),
          backgroundColor: DertamColors.red,
        ),
      );
      return;
    }
    
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    
    // Check if expense exceeds ANY budget limit (daily or total) - Only for new expenses
    bool isOverBudget = false;
    
    if (!widget.isEditing) {
      // For new expenses, check if it exceeds budget limits
      isOverBudget = _totalExpense > _availableBudgetForSelectedDay || _totalExpense > widget.remainingBudget;
      
      // Only show the warning dialog once per session
      if (isOverBudget && !budgetProvider.hasShownOverBudgetWarning) {
        // Debug flag state
        print("Is over budget: $isOverBudget");
        print("Has shown warning: ${budgetProvider.hasShownOverBudgetWarning}");
        
        bool shouldContinue = await _showBudgetExceededDialog();
        if (!shouldContinue) {
          return;
        }
        
        // Set flag in provider to prevent showing the dialog again
        budgetProvider.setOverBudgetWarningShown(true);
        print("Warning flag now set to: ${budgetProvider.hasShownOverBudgetWarning}");
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success;
      
      if (widget.isEditing && widget.expense != null) {
        // Update existing expense
        final updatedExpense = Expense(
          id: widget.expense!.id,
          amount: _totalExpense,
          category: _selectedCategory,
          date: DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            DateTime.now().hour,
            DateTime.now().minute,
            DateTime.now().second,
          ),
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : "No description",
          placeId: widget.expense!.placeId, // Preserve existing placeId
        );
        
        success = await budgetProvider.updateExpense(
          budgetId: widget.budgetId,
          updatedExpense: updatedExpense,
        );
      } else {
        // Add new expense
        success = await budgetProvider.addExpense(
          budgetId: widget.budgetId,
          amount: _totalExpense,
          category: _selectedCategory,
          date: DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            DateTime.now().hour,
            DateTime.now().minute,
            DateTime.now().second,
          ),
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : "No description",
        );
      }
      
      if (success) {
        // Return to the previous screen
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to ${widget.isEditing ? 'update' : 'add'} expense. Please try again."),
            backgroundColor: DertamColors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: DertamColors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Show confirmation dialog when exceeding budget
  Future<bool> _showBudgetExceededDialog() async {
    String budgetType = "";
    double budgetAmount = 0.0;
    
    // Determine which budget is exceeded for better message
    if (_totalExpense > widget.remainingBudget) {
      budgetType = "total";
      budgetAmount = widget.remainingBudget;
    } else {
      budgetType = "daily";
      budgetAmount = _availableBudgetForSelectedDay;
    }
    
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Budget Exceeded",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "This expense exceeds your $budgetType budget of ${widget.selectedCurrency} ${budgetAmount.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                Text(
                  "Are you sure you want to continue?",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                Text(
                  "Note: You won't be asked again for this session.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: DertamColors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                "Continue Anyway",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  // Build day dropdown with proper date handling
  Widget _buildDayDropdown() {
    if (_trip == null || _trip!.days.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Day",
          style: DertamTextStyles.body.copyWith(
            color: DertamColors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: DertamColors.greyLight),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: _selectedDayIndex,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              iconSize: 24,
              elevation: 16,
              style: DertamTextStyles.body.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: Colors.white,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  DateTime newDate = _trip!.startDate.add(Duration(days: newValue));
                  
                  setState(() {
                    _selectedDayIndex = newValue;
                    _selectedDate = newDate;
                    _updateAvailableBudget();
                  });
                }
              },
              items: List.generate(_trip!.days.length, (index) {
                
                return DropdownMenuItem<int>(
                  value: index,
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today, 
                        size: 18, 
                        color: DertamColors.primary,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formatDayForDropdown(index),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        
        // Show info text about daily budgets and available budget
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daily budget: ${widget.selectedCurrency} ${Provider.of<BudgetProvider>(context).selectedBudget?.dailyBudget.toStringAsFixed(2) ?? '0.00'}",
                style: TextStyle(
                  fontSize: 12,
                  color: DertamColors.grey,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Available for ${_getDateStatus(_selectedDate) == 'Today' ? 'today' : _getDateStatus(_selectedDate) == 'Future' ? 'future day' : 'past day'}: ${widget.selectedCurrency} ${_availableBudgetForSelectedDay.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 12,
                  color: _availableBudgetForSelectedDay > 0 ? DertamColors.green : DertamColors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.isEditing ? "Edit Expense" : "Add Expense"),
        backgroundColor: DertamColors.blueSky,
        actions: [
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _addExpense,
                  child: Text(widget.isEditing ? "Update" : "Save", style: TextStyle(color: Colors.black)),
                ),
        ],
      ),
      body: _isLoading && _trip == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total", style: DertamTextStyles.title),
                      Text("${widget.selectedCurrency} ${_totalExpense.toStringAsFixed(2)}",
                          style: DertamTextStyles.title),
                    ],
                  ),
                  SizedBox(height: DertamSpacings.m),
                  
                  // Day Dropdown
                  if (_trip != null && _trip!.days.isNotEmpty)
                    _buildDayDropdown(),
                  
                  SizedBox(height: DertamSpacings.m),
                  
                  // Category Selection
                  ListTile(
                    leading: Icon(_selectedCategory.icon),
                    title: Text(_selectedCategory.label),
                    trailing: Icon(Icons.arrow_drop_down),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: DertamColors.greyLight),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ListView(
                            children: ExpenseCategory.values
                                .map((category) => ListTile(
                                      leading: Icon(category.icon),
                                      title: Text(category.label),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = category;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ))
                                .toList(),
                          );
                        },
                      );
                    },
                  ),
                  
                  SizedBox(height: DertamSpacings.m),
                  
                  DertamTextfield(
                    label: "Expense Amount (${widget.selectedCurrency})",
                    controller: _expenseController,
                    keyboardType: TextInputType.number,
                    borderColor: DertamColors.greyLight,
                    onChanged: (value) => _calculateTotalExpense(),
                  ),
                  
                  SizedBox(height: DertamSpacings.s),
                  
                  DertamTextfield(
                    label: "Number of People",
                    controller: _peopleController,
                    keyboardType: TextInputType.number,
                    borderColor: DertamColors.greyLight,
                    onChanged: (value) => _calculateTotalExpense(),
                  ),
                  
                  SizedBox(height: DertamSpacings.s),
                  
                  DertamTextfield(
                    label: "Description",
                    controller: _descriptionController,
                    borderColor: DertamColors.greyLight,
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _expenseController.dispose();
    _descriptionController.dispose();
    _peopleController.dispose();
    super.dispose();
  }
}