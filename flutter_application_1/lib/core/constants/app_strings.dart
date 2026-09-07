class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'FundiLink';
  static const String appTagline = 'Connect with trusted local fundis';

  // Auth
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String phoneNumber = 'Phone Number';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String sendResetLink = 'Send Reset Link';
  static const String resetLinkSent =
      'If the account exists, a reset link has been sent.';
  static const String logoutConfirm = 'Are you sure you want to log out?';
  static const String backToLogin = 'Back to Login';
  static const String noAccount = "Don't have an account?";
  static const String hasAccount = 'Already have an account?';
  static const String createAccount = 'Create Account';
  static const String useDemoAccount = 'Use demo account';
  static const String useDemoFundi = 'Use fundi demo';
  static const String selectRole = 'I want to';
  static const String findFundi = 'Find a Fundi';
  static const String offerServices = 'Offer Services';
  static const String asCustomer = 'As a Customer';
  static const String asFundi = 'As a Fundi';

  // Validation
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordMinLength =
      'Password must be at least 6 characters';
  static const String passwordMismatch = 'Passwords do not match';
  static const String nameRequired = 'Name is required';
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid = 'Please enter a valid phone number';

  // Home
  static const String home = 'Home';
  static const String search = 'Search';
  static const String requests = 'Requests';
  static const String messages = 'Messages';
  static const String schedule = 'Schedule';
  static const String profile = 'Profile';
  static const String dashboard = 'Dashboard';
  static const String jobs = 'Jobs';

  // Home Screen
  static const String greeting = 'Hello, ';
  static const String goodMorning = 'Good morning';
  static const String goodAfternoon = 'Good afternoon';
  static const String goodEvening = 'Good evening';
  static const String homeSubtitle = 'What service do you need today?';
  static const String searchHint = 'What service do you need?';
  static const String popularCategories = 'Popular Categories';
  static const String viewAll = 'View All';
  static const String recommendedFundi = 'Recommended Fundis';
  static const String nearbyFundi = 'Nearby Fundis';
  static const String highlyRated = 'Highly Rated';
  static const String newArrivalsAvailable = 'New arrivals available';
  static const String sortHighestRated = 'Highest rated';
  static const String sortLowestPrice = 'Lowest price';
  static const String sortNearestFirst = 'Nearest first';
  static const String recentRequests = 'Recent Requests';
  static const String noResults = 'No results found';
  static const String noFundiAvailable = 'No fundis available nearby';

  // Categories
  static const String categories = 'Service Categories';
  static const String plumbing = 'Plumbing';
  static const String electrical = 'Electrical';
  static const String carpentry = 'Carpentry';
  static const String painting = 'Painting';
  static const String masonry = 'Masonry';
  static const String cleaning = 'Cleaning';
  static const String applianceRepair = 'Appliance Repair';
  static const String welding = 'Welding';
  static const String phoneComputerRepair = 'Phone/Computer Repair';
  static const String otherServices = 'Other Services';

  // Fundi Profile
  static const String fundiProfile = 'Fundi Profile';
  static const String about = 'About';
  static const String services = 'Services';
  static const String portfolio = 'Portfolio';
  static const String reviews = 'Reviews';
  static const String requestService = 'Request Service';
  static const String chat = 'Chat';
  static const String startingPrice = 'Starting from';
  static const String experience = 'Experience';
  static const String completedJobs = 'Completed Jobs';
  static const String years = 'years';
  static const String available = 'Available';
  static const String unavailable = 'Unavailable';

  // Service Request
  static const String requestAService = 'Request a Service';
  static const String describeProblem = 'Describe the problem';
  static const String problemDescription = 'Problem Description';
  static const String selectService = 'Select Service';
  static const String selectFundi = 'Select Fundi';
  static const String preferredDate = 'Preferred Date';
  static const String preferredTime = 'Preferred Time';
  static const String addLocation = 'Add Location';
  static const String location = 'Location';
  static const String uploadPhotos = 'Upload Photos';
  static const String optional = 'Optional';
  static const String submitRequest = 'Submit Request';
  static const String requestSubmitted = 'Request Submitted!';
  static const String requestConfirmed =
      'Your request has been sent to the fundi';
  static const String requestPending = 'Waiting for fundi to accept';
  static const String estimatedCost = 'Estimated Cost';

  // Request Status
  static const String pending = 'Pending';
  static const String accepted = 'Accepted';
  static const String inProgress = 'In Progress';
  static const String completed = 'Completed';
  static const String reviewed = 'Reviewed';
  static const String rejected = 'Rejected';

  // Requests
  static const String myRequests = 'My Requests';
  static const String noRequests = 'No service requests yet';
  static const String noRequestsTitle = 'No requests';
  static const String noFundiRequestsHint =
      "When customers request your services, they'll appear here.";
  static const String requestsEmptyHint =
      'Browse fundis and request a service to get started.';
  static const String requestDetails = 'Request Details';
  static const String accept = 'Accept';
  static const String reject = 'Reject';
  static const String startWork = 'Start Work';
  static const String markComplete = 'Mark as Complete';
  static const String acceptRequestConfirm = 'Accept this request?';
  static const String acceptRequestHint =
      "You'll be expected to contact the customer and complete the work.";
  static const String rejectRequestConfirm = 'Reject this request?';
  static const String rejectRequestHint =
      'The customer will be notified that you declined.';
  static const String startWorkConfirm = 'Start work?';
  static const String startWorkHint = 'Mark this request as in progress.';
  static const String markCompleteConfirm = 'Mark as complete?';
  static const String markCompleteHint =
      'The customer will be notified that the work is done.';
  static const String cancelRequest = 'Cancel Request';
  static const String cancelThisRequest = 'Cancel this request?';
  static const String cancelRequestHint =
      'The fundi will be notified that this request was cancelled.';
  static const String requestCancelled = 'Request cancelled.';
  static const String messageFundi = 'Message fundi';
  static const String requestSubmitFailed =
      'Failed to submit your request. Please try again.';
  static const String backToHome = 'Back to Home';

  // Chat
  static const String typeMessage = 'Type a message...';
  static const String send = 'Send';
  static const String noMessages = 'No messages yet';
  static const String startConversation = 'Start a conversation';
  static const String noConversations = 'No conversations yet';
  static const String noConversationsHint =
      'Request a service or tap chat on a fundi profile to get started.';

  // Notifications
  static const String notifications = 'Notifications';
  static const String noNotifications = 'No notifications';
  static const String noNotificationsHint =
      'Updates about your requests and chats will appear here.';
  static const String markAllRead = 'Mark all as read';

  // Profile
  static const String myProfile = 'My Profile';
  static const String editProfile = 'Edit Profile';
  static const String roleCustomer = 'Customer';
  static const String roleFundi = 'Fundi';
  static const String settings = 'Settings';
  static const String language = 'Language';
  static const String help = 'Help & Support';
  static const String aboutApp = 'About FundiLink';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';

  // Settings
  static const String accountSection = 'Account';
  static const String appSection = 'App';
  static const String supportSection = 'Support';
  static const String changePassword = 'Change Password';
  static const String darkMode = 'Dark mode';
  static const String pushNotifications = 'Push Notifications';
  static const String english = 'English';
  static const String notificationsEnabled = 'Notifications enabled';
  static const String notificationsDisabled = 'Notifications disabled';
  static const String profileEditingComingSoon =
      'Profile editing is on the way';
  static const String passwordChangeComingSoon =
      'Password change is on the way';
  static const String languageSelectionComingSoon =
      'Language selection is on the way';
  static const String privacyPolicyComingSoon = 'Privacy policy is on the way';
  static const String termsComingSoon = 'Terms of service is on the way';

  // Reviews
  static const String writeReview = 'Write a Review';
  static const String rating = 'Rating';
  static const String reviewText = 'Your Review';
  static const String submitReview = 'Submit Review';
  static const String noReviews = 'No reviews yet';
  static const String noReviewsHint =
      'Reviews from customers will appear here.';
  static const String averageRating = 'Average Rating';

  // Fundi Dashboard
  static const String earnings = 'Earnings';
  static const String todayStats = "Today's Stats";
  static const String pendingRequests = 'Pending Requests';
  static const String activeJobs = 'Active Jobs';
  static const String totalEarnings = 'Total Earnings';
  static const String recentActivity = 'Recent Activity';

  // Jobs
  static const String jobsActive = 'Active';
  static const String jobsCompleted = 'Completed';
  static const String noActiveJobs = 'No active jobs right now.';
  static const String noCompletedJobs = 'Completed jobs will appear here.';

  // Fundi Profile Management
  static const String manageProfile = 'Manage Profile';
  static const String serviceCategories = 'Service Categories';
  static const String addDescription = 'Add Description';
  static const String experienceLevel = 'Experience Level';
  static const String pricing = 'Pricing';
  static const String addPortfolio = 'Add Portfolio';
  static const String manageAvailability = 'Manage Availability';
  static const String availability = 'Availability';

  // Portfolio
  static const String myPortfolio = 'My Portfolio';
  static const String addWork = 'Add Work';
  static const String noPortfolio = 'No portfolio items yet';
  static const String noPortfolioHint =
      'Showcase your best work to attract more customers.';
  static const String uploadWork = 'Upload Work Image';

  // Availability
  static const String workingDays = 'Working Days';
  static const String workingHours = 'Working Hours';
  static const String startTime = 'Start Time';
  static const String endTime = 'End Time';
  static const String availableForNewRequests =
      'You are available for new requests';
  static const String unavailableForNewRequests =
      "You won't receive new requests";
  static const String availabilitySaved = 'Availability saved';

  // Earnings
  static const String myEarnings = 'My Earnings';
  static const String totalEarned = 'Total Earned';
  static const String thisMonth = 'This Month';
  static const String jobHistory = 'Job History';
  static const String earningsGrowing = 'Your earnings are growing';
  static const String noCompletedJobsYet = 'No completed jobs yet.';
  static const String noRecentActivityYet = 'No recent activity yet.';

  static const String profileUpdated = 'Profile updated successfully';

  // Common
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String close = 'Close';
  static const String confirm = 'Confirm';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String ok = 'OK';
  static const String comingSoon = 'This feature is coming soon';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String apply = 'Apply';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String all = 'All';
  static const String filterAndSort = 'Filter & Sort';
  static const String sortByLabel = 'Sort by';
  static const String categoryLabel = 'Category';
  static const String highestRated = 'Highest Rated';
  static const String lowestPrice = 'Lowest Price';
  static const String nearest = 'Nearest';
  static const String availableOnly = 'Available only';
  static const String verifiedOnly = 'Verified only';
  static const String discoverFundisNearYou = 'Discover fundis near you';
  static const String searchEmptyMessage =
      'Type a service, name or location above, or pick a category.';
  static const String noResultsHint =
      'Try a different search term or category.';
  static const String clearSearch = 'Clear search';
  static const String showPassword = 'Show password';
  static const String hidePassword = 'Hide password';

  // Image Picker
  static const String selectImageSource = 'Select Image Source';
  static const String camera = 'Camera';
  static const String gallery = 'Gallery';
  static const String km = 'km away';
  static const String perHour = '/hour';
  static const String perJob = '/job';

  // Onboarding
  static const String onboardingTitle1 = 'Find Trusted Fundis';
  static const String onboardingDesc1 =
      'Connect with verified and skilled fundis in your area for all your service needs.';
  static const String onboardingTitle2 = 'Book Services Easily';
  static const String onboardingDesc2 =
      'Describe your problem, choose a time, and book a fundi with just a few taps.';
  static const String onboardingTitle3 = 'Track & Review';
  static const String onboardingDesc3 =
      'Track your service requests in real-time and leave reviews to help others.';
  static const String getStarted = 'Get Started';
  static const String skip = 'Skip';

  // Error Messages
  static const String somethingWentWrong = 'Something went wrong';
  static const String networkError =
      'Network error. Please check your connection.';
  static const String sessionExpired = 'Session expired. Please login again.';
}
