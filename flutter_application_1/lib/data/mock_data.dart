import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../models/availability.dart';
import '../models/chat_message.dart';
import '../models/conversation.dart';
import '../models/fundi_model.dart';
import '../models/notification_item.dart';
import '../models/portfolio_item.dart';
import '../models/review.dart';
import '../models/service_category.dart';
import '../models/service_request.dart';
import '../models/user_model.dart';

/// Mock users used until the backend is connected.
const User mockCustomer = User(
  id: 'u1',
  fullName: 'Brian Kimani',
  email: 'brian@example.com',
  phone: '+254711223344',
  role: UserRole.customer,
  location: 'Nairobi, Kenya',
);

const User mockFundiUser = User(
  id: 'uf1',
  fullName: 'James Otieno',
  email: 'james@example.com',
  phone: '+254722556677',
  role: UserRole.fundi,
  location: 'Nairobi, Kenya',
);

/// Static sample data powering the app until a backend is connected.
class MockData {
  MockData._();

  static DateTime _minutesAgo(int minutes) =>
      DateTime.now().subtract(Duration(minutes: minutes));

  // ---------------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------------
  static final List<ServiceCategory> categories = [
    const ServiceCategory(
      id: 'cat_plumbing',
      name: AppStrings.plumbing,
      icon: Icons.plumbing,
      color: AppColors.categoryPlumbing,
      description: 'Fixing leaks, pipes, sinks, water heaters and drainage.',
      jobCount: 1240,
    ),
    const ServiceCategory(
      id: 'cat_electrical',
      name: AppStrings.electrical,
      icon: Icons.electrical_services,
      color: AppColors.categoryElectrical,
      description: 'Wiring, lighting, sockets, switches and electrical repairs.',
      jobCount: 980,
    ),
    const ServiceCategory(
      id: 'cat_carpentry',
      name: AppStrings.carpentry,
      icon: Icons.handyman,
      color: AppColors.categoryCarpentry,
      description: 'Furniture, cabinets, doors, woodwork and installations.',
      jobCount: 760,
    ),
    const ServiceCategory(
      id: 'cat_painting',
      name: AppStrings.painting,
      icon: Icons.format_paint,
      color: AppColors.categoryPainting,
      description: 'Interior and exterior painting, décor and touch-ups.',
      jobCount: 540,
    ),
    const ServiceCategory(
      id: 'cat_masonry',
      name: AppStrings.masonry,
      icon: Icons.bricks,
      color: AppColors.categoryMasonry,
      description: 'Brickwork, walls, pavements and concrete structures.',
      jobCount: 430,
    ),
    const ServiceCategory(
      id: 'cat_cleaning',
      name: AppStrings.cleaning,
      icon: Icons.cleaning_services,
      color: AppColors.categoryCleaning,
      description: 'Home, office and post-construction cleaning services.',
      jobCount: 810,
    ),
    const ServiceCategory(
      id: 'cat_appliance',
      name: AppStrings.applianceRepair,
      icon: Icons.kitchen,
      color: AppColors.categoryAppliance,
      description: 'Repair and servicing of fridges, ovens, washing machines.',
      jobCount: 350,
    ),
    const ServiceCategory(
      id: 'cat_welding',
      name: AppStrings.welding,
      icon: Icons.hardware,
      color: AppColors.categoryWelding,
      description: 'Metal fabrication, gates, railings and structural welding.',
      jobCount: 280,
    ),
    const ServiceCategory(
      id: 'cat_repair',
      name: AppStrings.phoneComputerRepair,
      icon: Icons.phone_android,
      color: AppColors.categoryRepair,
      description: 'Phone, tablet and computer screen and software repairs.',
      jobCount: 620,
    ),
    const ServiceCategory(
      id: 'cat_other',
      name: AppStrings.otherServices,
      icon: Icons.miscellaneous_services,
      color: AppColors.categoryOther,
      description: 'Any other skilled service you need done.',
      jobCount: 190,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Fundis
  // ---------------------------------------------------------------------------
  static final List<Fundi> fundis = [
    const Fundi(
      id: 'f1',
      fullName: 'James Otieno',
      categoryId: 'cat_plumbing',
      categoryName: AppStrings.plumbing,
      description:
          'Certified plumber with over 8 years of experience. I handle leak '
          'repairs, pipe installations, water heaters, drainage and bathroom '
          'renovations. Fast, clean and honest pricing.',
      experienceYears: 8,
      location: 'South B, Nairobi',
      city: 'Nairobi',
      distanceKm: 2.3,
      rating: 4.8,
      ratingCount: 214,
      completedJobs: 214,
      startingPrice: 800,
      priceUnit: AppStrings.perJob,
      isAvailable: true,
      verified: true,
      responseTimeMinutes: 15,
      serviceTags: ['Leaks', 'Pipes', 'Water Heaters', 'Drainage'],
      portfolioImages: [
        'https://picsum.photos/seed/plumb1/600/600',
        'https://picsum.photos/seed/plumb2/600/600',
        'https://picsum.photos/seed/plumb3/600/600',
      ],
    ),
    const Fundi(
      id: 'f2',
      fullName: 'Mary Wanjiku',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      categoryId: 'cat_electrical',
      categoryName: AppStrings.electrical,
      description:
          'Licensed electrician specializing in safe domestic wiring, lighting '
          'installation, fault tracing and inspections. I prioritize safety and '
          'quality workmanship on every job.',
      experienceYears: 6,
      location: 'Kilimani, Nairobi',
      city: 'Nairobi',
      distanceKm: 1.8,
      rating: 4.9,
      ratingCount: 168,
      completedJobs: 168,
      startingPrice: 1200,
      priceUnit: AppStrings.perHour,
      isAvailable: true,
      verified: true,
      responseTimeMinutes: 10,
      serviceTags: ['Wiring', 'Lighting', 'Inspections', 'Fault Finding'],
      portfolioImages: [],
    ),
    const Fundi(
      id: 'f3',
      fullName: 'Peter Kiprono',
      categoryId: 'cat_carpentry',
      categoryName: AppStrings.carpentry,
      description:
          'Master carpenter and cabinet maker. I build custom furniture, '
          'kitchen cabinets, doors and wardrobes with a strong eye for detail '
          'and durable finishing.',
      experienceYears: 10,
      location: 'Ruiru',
      city: 'Kiambu',
      distanceKm: 5.2,
      rating: 4.6,
      ratingCount: 143,
      completedJobs: 143,
      startingPrice: 1500,
      priceUnit: AppStrings.perJob,
      isAvailable: true,
      verified: true,
      responseTimeMinutes: 30,
      serviceTags: ['Furniture', 'Cabinets', 'Doors', 'Wardrobes'],
      portfolioImages: [],
    ),
    const Fundi(
      id: 'f4',
      fullName: 'Grace Achieng',
      categoryId: 'cat_cleaning',
      categoryName: AppStrings.cleaning,
      description:
          'Professional home and office cleaner. Deep cleaning, move-in/move-out '
          'cleaning, carpet care and post-construction cleanup. I bring all '
          'equipment and eco-friendly supplies.',
      experienceYears: 5,
      location: 'Lavington, Nairobi',
      city: 'Nairobi',
      distanceKm: 3.1,
      rating: 4.7,
      ratingCount: 231,
      completedJobs: 231,
      startingPrice: 600,
      priceUnit: AppStrings.perHour,
      isAvailable: true,
      verified: false,
      responseTimeMinutes: 20,
      serviceTags: ['Deep Clean', 'Move-out', 'Carpets', 'Offices'],
      portfolioImages: [],
    ),
    const Fundi(
      id: 'f5',
      fullName: 'David Mwangi',
      categoryId: 'cat_painting',
      categoryName: AppStrings.painting,
      description:
          'Painting contractor for homes and businesses. Interior and exterior '
          'painting, waterproofing, wall preparation and color consulting.',
      experienceYears: 7,
      location: 'Westlands, Nairobi',
      city: 'Nairobi',
      distanceKm: 4.0,
      rating: 4.5,
      ratingCount: 121,
      completedJobs: 121,
      startingPrice: 1000,
      priceUnit: AppStrings.perHour,
      isAvailable: false,
      verified: true,
      responseTimeMinutes: 45,
      serviceTags: ['Interiors', 'Exteriors', 'Waterproofing'],
      portfolioImages: [],
    ),
    const Fundi(
      id: 'f6',
      fullName: 'Samuel Baraka',
      categoryId: 'cat_masonry',
      categoryName: AppStrings.masonry,
      description:
          'Experienced mason for foundations, walls, paving and concrete work. '
          'Reliable for both small repairs and full construction projects.',
      experienceYears: 12,
      location: 'Kangundo Road',
      city: 'Machakos',
      distanceKm: 12.0,
      rating: 4.4,
      ratingCount: 198,
      completedJobs: 198,
      startingPrice: 1800,
      priceUnit: AppStrings.perJob,
      isAvailable: true,
      verified: false,
      responseTimeMinutes: 60,
      serviceTags: ['Walls', 'Paving', 'Foundations'],
      portfolioImages: [],
    ),
    const Fundi(
      id: 'f7',
      fullName: 'Esther Njeri',
      categoryId: 'cat_appliance',
      categoryName: AppStrings.applianceRepair,
      description:
          'Appliance technician. I repair refrigerators, ovens, washing '
          'machines and microwaves at your home, with genuine spare parts.',
      experienceYears: 4,
      location: 'Donholm, Nairobi',
      city: 'Nairobi',
      distanceKm: 2.7,
      rating: 4.8,
      ratingCount: 96,
      completedJobs: 96,
      startingPrice: 900,
      priceUnit: AppStrings.perHour,
      isAvailable: true,
      verified: false,
      responseTimeMinutes: 25,
      serviceTags: ['Fridges', 'Ovens', 'Washers'],
      portfolioImages: [],
    ),
    const Fundi(
      id: 'f8',
      fullName: 'Kevin Odhiambo',
      categoryId: 'cat_welding',
      categoryName: AppStrings.welding,
      description:
          'Welder and metal fabricator. Gates, grills, railings, structural '
          'steel and custom metal works. Quality welds with proper finishing.',
      experienceYears: 9,
      location: 'Industrial Area',
      city: 'Nairobi',
      distanceKm: 8.9,
      rating: 4.3,
      ratingCount: 87,
      completedJobs: 87,
      startingPrice: 2000,
      priceUnit: AppStrings.perJob,
      isAvailable: true,
      verified: false,
      responseTimeMinutes: 40,
      serviceTags: ['Gates', 'Railings', 'Steel Works'],
      portfolioImages: [],
    ),
    const Fundi(
      id: 'f9',
      fullName: 'Faith Chebet',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
      categoryId: 'cat_repair',
      categoryName: AppStrings.phoneComputerRepair,
      description:
          'Phone and computer repair expert. Screen replacements, battery '
          'service, software issues and data recovery for all major brands. '
          'Same-day service for most repairs.',
      experienceYears: 6,
      location: 'CBD, Nairobi',
      city: 'Nairobi',
      distanceKm: 1.2,
      rating: 4.9,
      ratingCount: 312,
      completedJobs: 312,
      startingPrice: 700,
      priceUnit: AppStrings.perJob,
      isAvailable: true,
      verified: true,
      responseTimeMinutes: 5,
      serviceTags: ['Screens', 'Batteries', 'Software', 'Data Recovery'],
      portfolioImages: [],
    ),
    const Fundi(
      id: 'f10',
      fullName: 'Joseph Kamau',
      categoryId: 'cat_plumbing',
      categoryName: AppStrings.plumbing,
      description:
          'Plumber offering affordable and reliable repairs for residential '
          'and commercial properties. Emergency call-outs available.',
      experienceYears: 5,
      location: 'Ruiru',
      city: 'Kiambu',
      distanceKm: 6.5,
      rating: 4.2,
      ratingCount: 154,
      completedJobs: 154,
      startingPrice: 750,
      priceUnit: AppStrings.perJob,
      isAvailable: true,
      verified: false,
      responseTimeMinutes: 35,
      serviceTags: ['Repairs', 'Installs', 'Emergencies'],
      portfolioImages: [],
    ),
    const Fundi(
      id: 'f11',
      fullName: 'Lucy Atieno',
      categoryId: 'cat_electrical',
      categoryName: AppStrings.electrical,
      description:
          'Electrician with a focus on modern LED installations, garden '
          'lighting and smart home upgrades. Neat, tidy and professional.',
      experienceYears: 3,
      location: 'Kasarani, Nairobi',
      city: 'Nairobi',
      distanceKm: 2.0,
      rating: 4.6,
      ratingCount: 77,
      completedJobs: 77,
      startingPrice: 1100,
      priceUnit: AppStrings.perHour,
      isAvailable: true,
      verified: false,
      responseTimeMinutes: 30,
      serviceTags: ['LED', 'Garden Lights', 'Smart Home'],
      portfolioImages: [],
    ),
    const Fundi(
      id: 'f12',
      fullName: 'Michael Moi',
      categoryId: 'cat_carpentry',
      categoryName: AppStrings.carpentry,
      description:
          'Carpenter for quality timber work: roofs, floors, pergolas and '
          'custom joinery. Twenty years of hands-on experience.',
      experienceYears: 11,
      location: 'Thika',
      city: 'Thika',
      distanceKm: 22.0,
      rating: 4.7,
      ratingCount: 132,
      completedJobs: 132,
      startingPrice: 1600,
      priceUnit: AppStrings.perJob,
      isAvailable: true,
      verified: true,
      responseTimeMinutes: 50,
      serviceTags: ['Roofs', 'Floors', 'Joinery'],
      portfolioImages: [],
    ),
  ];

  // ---------------------------------------------------------------------------
  // Service requests
  // ---------------------------------------------------------------------------
  static final List<ServiceRequest> requests = [
    ServiceRequest(
      id: 'r1',
      customerId: 'u1',
      customerName: 'Brian Kimani',
      fundiId: 'f1',
      fundiName: 'James Otieno',
      fundiAvatar: null,
      categoryId: 'cat_plumbing',
      categoryName: AppStrings.plumbing,
      description:
          'The kitchen sink is leaking from underneath and the pipe fitting '
          'needs replacing. Water pools on the floor when the tap runs.',
      status: RequestStatus.pending,
      preferredDate: 'Sep 6, 2026',
      preferredTime: '10:00 AM',
      location: 'South B, Nairobi',
      images: const [],
      estimatedCost: 800,
      createdAt: _minutesAgo(35),
    ),
    ServiceRequest(
      id: 'r2',
      customerId: 'u1',
      customerName: 'Brian Kimani',
      fundiId: 'f4',
      fundiName: 'Grace Achieng',
      categoryId: 'cat_cleaning',
      categoryName: AppStrings.cleaning,
      description: 'Deep cleaning of a 2-bedroom apartment after renovation.',
      status: RequestStatus.inProgress,
      preferredDate: 'Sep 4, 2026',
      preferredTime: '9:00 AM',
      location: 'Lavington, Nairobi',
      images: const ['https://picsum.photos/seed/dirty1/600/600'],
      estimatedCost: 3600,
      createdAt: _minutesAgo(600),
      updatedAt: _minutesAgo(180),
    ),
    ServiceRequest(
      id: 'r3',
      customerId: 'u1',
      customerName: 'Brian Kimani',
      fundiId: 'f2',
      fundiName: 'Mary Wanjiku',
      categoryId: 'cat_electrical',
      categoryName: AppStrings.electrical,
      description:
          'Lights flicker in the living room when the AC is on. Need the '
          'circuit checked and fixed.',
      status: RequestStatus.completed,
      preferredDate: 'Aug 29, 2026',
      preferredTime: '2:00 PM',
      location: 'Kilimani, Nairobi',
      images: const [],
      estimatedCost: 1800,
      createdAt: _minutesAgo(4320),
      updatedAt: _minutesAgo(2880),
    ),
    ServiceRequest(
      id: 'r4',
      customerId: 'u1',
      customerName: 'Brian Kimani',
      fundiId: 'f9',
      fundiName: 'Faith Chebet',
      categoryId: 'cat_repair',
      categoryName: AppStrings.phoneComputerRepair,
      description: 'Phone screen cracked after a fall. Replace with original.',
      status: RequestStatus.reviewed,
      preferredDate: 'Aug 20, 2026',
      preferredTime: '11:30 AM',
      location: 'CBD, Nairobi',
      images: const [],
      estimatedCost: 4500,
      createdAt: _minutesAgo(12960),
      updatedAt: _minutesAgo(11520),
    ),
    ServiceRequest(
      id: 'r5',
      customerId: 'u1',
      customerName: 'Brian Kimani',
      fundiId: 'f3',
      fundiName: 'Peter Kiprono',
      categoryId: 'cat_carpentry',
      categoryName: AppStrings.carpentry,
      description: 'Build and install 4 custom kitchen cabinet doors with soft close hinges.',
      status: RequestStatus.accepted,
      preferredDate: 'Sep 8, 2026',
      preferredTime: '9:30 AM',
      location: 'Ruiru',
      images: const [],
      estimatedCost: 6500,
      createdAt: _minutesAgo(1440),
      updatedAt: _minutesAgo(900),
    ),
    ServiceRequest(
      id: 'r6',
      customerId: 'u1',
      customerName: 'Brian Kimani',
      fundiId: 'f1',
      fundiName: 'James Otieno',
      categoryId: 'cat_plumbing',
      categoryName: AppStrings.plumbing,
      description: 'Bathroom water heater not heating. Thermostat issue.',
      status: RequestStatus.completed,
      preferredDate: 'Aug 15, 2026',
      preferredTime: '4:00 PM',
      location: 'South B, Nairobi',
      images: const [],
      estimatedCost: 2200,
      createdAt: _minutesAgo(20160),
      updatedAt: _minutesAgo(18720),
    ),
    // Requests arriving for the fundi (James Otieno) from other customers.
    ServiceRequest(
      id: 'r7',
      customerId: 'u7',
      customerName: 'Ann Wairimu',
      fundiId: 'f1',
      fundiName: 'James Otieno',
      categoryId: 'cat_plumbing',
      categoryName: AppStrings.plumbing,
      description: 'Toilet keeps running after flushing. Please fix the flush valve.',
      status: RequestStatus.pending,
      preferredDate: 'Sep 5, 2026',
      preferredTime: '8:00 AM',
      location: 'Langata, Nairobi',
      images: const [],
      estimatedCost: 900,
      createdAt: _minutesAgo(90),
    ),
    ServiceRequest(
      id: 'r8',
      customerId: 'u8',
      customerName: 'Tom Ochieng',
      fundiId: 'f1',
      fundiName: 'James Otieno',
      categoryId: 'cat_plumbing',
      categoryName: AppStrings.plumbing,
      description: 'Install a new kitchen sink and connect the dishwasher outlet.',
      status: RequestStatus.accepted,
      preferredDate: 'Sep 7, 2026',
      preferredTime: '1:00 PM',
      location: 'Buruburu, Nairobi',
      images: const [],
      estimatedCost: 3500,
      createdAt: _minutesAgo(1440),
      updatedAt: _minutesAgo(1200),
    ),
    ServiceRequest(
      id: 'r9',
      customerId: 'u9',
      customerName: 'Winnie Moraa',
      fundiId: 'f1',
      fundiName: 'James Otieno',
      categoryId: 'cat_plumbing',
      categoryName: AppStrings.plumbing,
      description: 'Burst pipe under the bathroom sink leaking into the kitchen ceiling.',
      status: RequestStatus.inProgress,
      preferredDate: 'Sep 3, 2026',
      preferredTime: '3:00 PM',
      location: 'South C, Nairobi',
      images: const ['https://picsum.photos/seed/pipe9/600/600'],
      estimatedCost: 2800,
      createdAt: _minutesAgo(2880),
      updatedAt: _minutesAgo(1500),
    ),
  ];

  // ---------------------------------------------------------------------------
  // Conversations & messages
  // ---------------------------------------------------------------------------
  static final List<Conversation> conversations = [
    Conversation(
      id: 'c1',
      otherUserId: 'f1',
      otherUserName: 'James Otieno',
      requestId: 'r1',
      requestTitle: 'Kitchen sink leaking',
      lastMessage: 'I can come by tomorrow morning at 10. Does that work?',
      lastMessageAt: _minutesAgo(18),
      unreadCount: 2,
    ),
    Conversation(
      id: 'c2',
      otherUserId: 'f2',
      otherUserName: 'Mary Wanjiku',
      requestId: 'r3',
      requestTitle: 'Flickering lights',
      lastMessage: 'All fixed, let me know if it happens again.',
      lastMessageAt: _minutesAgo(2900),
    ),
    Conversation(
      id: 'c3',
      otherUserId: 'f4',
      otherUserName: 'Grace Achieng',
      requestId: 'r2',
      requestTitle: 'Apartment deep cleaning',
      lastMessage: 'Done with the cleaning, thank you!',
      lastMessageAt: _minutesAgo(200),
    ),
    Conversation(
      id: 'c4',
      otherUserId: 'f9',
      otherUserName: 'Faith Chebet',
      requestId: 'r4',
      requestTitle: 'Phone screen replacement',
      lastMessage: 'Your phone is ready for pickup 👍',
      lastMessageAt: _minutesAgo(11500),
    ),
  ];

  static final Map<String, List<ChatMessage>> messagesByConversation = {
    'c1': [
      ChatMessage(
        id: 'm1',
        conversationId: 'c1',
        senderId: 'u1',
        text: 'Hi James, is the leaking kitchen sink fixable today?',
        timestamp: _minutesAgo(40),
        isRead: true,
      ),
      ChatMessage(
        id: 'm2',
        conversationId: 'c1',
        senderId: 'f1',
        text: 'Hi Brian, yes. The pipe fitting usually takes about an hour.',
        timestamp: _minutesAgo(32),
        isRead: true,
      ),
      ChatMessage(
        id: 'm3',
        conversationId: 'c1',
        senderId: 'u1',
        text: 'Great. I can send a photo of the leak.',
        timestamp: _minutesAgo(25),
        isRead: true,
      ),
      ChatMessage(
        id: 'm4',
        conversationId: 'c1',
        senderId: 'f1',
        text: 'Sure, that will help me prepare the right fittings.',
        timestamp: _minutesAgo(20),
        isRead: false,
      ),
      ChatMessage(
        id: 'm5',
        conversationId: 'c1',
        senderId: 'f1',
        text: 'I can come by tomorrow morning at 10. Does that work?',
        timestamp: _minutesAgo(18),
        isRead: false,
      ),
    ],
    'c2': [
      ChatMessage(
        id: 'm6',
        conversationId: 'c2',
        senderId: 'u1',
        text: 'Hello Mary, the lights are flickering in the living room.',
        timestamp: _minutesAgo(4400),
        isRead: true,
      ),
      ChatMessage(
        id: 'm7',
        conversationId: 'c2',
        senderId: 'f2',
        text: 'I will check the circuit. Are you around on Friday afternoon?',
        timestamp: _minutesAgo(4350),
        isRead: true,
      ),
      ChatMessage(
        id: 'm8',
        conversationId: 'c2',
        senderId: 'f2',
        text: 'All fixed, let me know if it happens again.',
        timestamp: _minutesAgo(2900),
        isRead: true,
      ),
    ],
    'c3': [
      ChatMessage(
        id: 'm9',
        conversationId: 'c3',
        senderId: 'u1',
        text: 'The apartment needs a deep clean after renovations.',
        timestamp: _minutesAgo(700),
        isRead: true,
      ),
      ChatMessage(
        id: 'm10',
        conversationId: 'c3',
        senderId: 'f4',
        text: 'No problem, I will bring the equipment. 3 hours should do it.',
        timestamp: _minutesAgo(650),
        isRead: true,
      ),
      ChatMessage(
        id: 'm11',
        conversationId: 'c3',
        senderId: 'f4',
        text: 'Done with the cleaning, thank you!',
        timestamp: _minutesAgo(200),
        isRead: true,
      ),
    ],
    'c4': [
      ChatMessage(
        id: 'm12',
        conversationId: 'c4',
        senderId: 'u1',
        text: 'Hi, how long does a screen replacement take?',
        timestamp: _minutesAgo(13000),
        isRead: true,
      ),
      ChatMessage(
        id: 'm13',
        conversationId: 'c4',
        senderId: 'f9',
        text: 'Usually 1 hour for most models.',
        timestamp: _minutesAgo(12950),
        isRead: true,
      ),
      ChatMessage(
        id: 'm14',
        conversationId: 'c4',
        senderId: 'f9',
        text: 'Your phone is ready for pickup 👍',
        timestamp: _minutesAgo(11500),
        isRead: true,
      ),
    ],
  };

  // ---------------------------------------------------------------------------
  // Reviews
  // ---------------------------------------------------------------------------
  static final List<Review> reviews = [
    Review(
      id: 'rev1',
      fundiId: 'f1',
      customerName: 'Ann Wairimu',
      rating: 5,
      comment: 'James fixed our burst pipe quickly and left everything clean. Highly recommend!',
      createdAt: _minutesAgo(1500),
    ),
    Review(
      id: 'rev2',
      fundiId: 'f1',
      customerName: 'Tom Ochieng',
      rating: 4.5,
      comment: 'Good work on the water heater. Arrived on time and gave fair pricing.',
      createdAt: _minutesAgo(4000),
    ),
    Review(
      id: 'rev3',
      fundiId: 'f1',
      customerName: 'Nancy Wambui',
      rating: 5,
      comment: 'Very professional and knowledgeable. Will call him again.',
      createdAt: _minutesAgo(9000),
    ),
    Review(
      id: 'rev4',
      fundiId: 'f2',
      customerName: 'Brian Kimani',
      rating: 5,
      comment: 'Mary traced the wiring fault in no time. Safe and tidy work.',
      createdAt: _minutesAgo(2800),
    ),
    Review(
      id: 'rev5',
      fundiId: 'f2',
      customerName: 'Faith Muthoni',
      rating: 4.5,
      comment: 'Excellent lighting installation. Slightly pricey but worth it.',
      createdAt: _minutesAgo(7000),
    ),
    Review(
      id: 'rev6',
      fundiId: 'f4',
      customerName: 'Brian Kimani',
      rating: 5,
      comment: 'The apartment has never been this clean. Great attention to detail.',
      createdAt: _minutesAgo(150),
    ),
    Review(
      id: 'rev7',
      fundiId: 'f4',
      customerName: 'Kevin Otieno',
      rating: 4,
      comment: 'Good job. Arrived a bit late but the results were excellent.',
      createdAt: _minutesAgo(5000),
    ),
    Review(
      id: 'rev8',
      fundiId: 'f9',
      customerName: 'Brian Kimani',
      rating: 5,
      comment: 'Screen replaced same day. Works like new!',
      createdAt: _minutesAgo(11500),
    ),
  ];

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------
  static final List<NotificationItem> notifications = [
    NotificationItem(
      id: 'n1',
      type: 'chat',
      title: 'New message from James Otieno',
      body: 'I can come by tomorrow morning at 10. Does that work?',
      createdAt: _minutesAgo(18),
    ),
    NotificationItem(
      id: 'n2',
      type: 'request',
      title: 'Request accepted',
      body: 'Peter Kiprono accepted your cabinet doors request.',
      createdAt: _minutesAgo(900),
      isRead: true,
    ),
    NotificationItem(
      id: 'n3',
      type: 'request',
      title: 'Work in progress',
      body: 'Grace Achieng started cleaning your apartment.',
      createdAt: _minutesAgo(180),
      isRead: true,
    ),
    NotificationItem(
      id: 'n4',
      type: 'review',
      title: 'New review received',
      body: 'Your request was reviewed. Thanks for the feedback!',
      createdAt: _minutesAgo(11500),
      isRead: true,
    ),
    NotificationItem(
      id: 'n5',
      type: 'request',
      title: 'Request completed',
      body: 'Mary Wanjiku completed the electrical repair.',
      createdAt: _minutesAgo(2880),
      isRead: true,
    ),
    NotificationItem(
      id: 'n6',
      type: 'system',
      title: 'Welcome to FundiLink',
      body: 'Browse fundis near you and book your first service today.',
      createdAt: _minutesAgo(20160),
      isRead: true,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Availability & portfolio
  // ---------------------------------------------------------------------------
  static final List<Availability> availabilities = List.generate(
    fundis.length,
    (i) => Availability(
      fundiId: fundis[i].id,
      isAvailable: true,
      workingDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      startTime: '08:00',
      endTime: '18:00',
    ),
  );

  static final List<PortfolioItem> portfolioItems = [
    const PortfolioItem(
      id: 'p1',
      fundiId: 'f1',
      title: 'Bathroom pipe replacement',
      description: 'Replaced corroded pipes in a family home in South B.',
      imageUrl: 'https://picsum.photos/seed/plumb1/600/600',
    ),
    const PortfolioItem(
      id: 'p2',
      fundiId: 'f1',
      title: 'Water heater installation',
      description: 'Installed a 50L water heater with proper safety wiring.',
      imageUrl: 'https://picsum.photos/seed/plumb2/600/600',
    ),
    const PortfolioItem(
      id: 'p3',
      fundiId: 'f1',
      title: 'Kitchen drain unblocking',
      description: 'Unblocked a stubborn kitchen drain using a jetting machine.',
      imageUrl: 'https://picsum.photos/seed/plumb3/600/600',
    ),
    const PortfolioItem(
      id: 'p4',
      fundiId: 'f2',
      title: 'Living room lighting',
      description: 'Installed recessed LED lighting with dimmers.',
      imageUrl: 'https://picsum.photos/seed/light1/600/600',
    ),
    const PortfolioItem(
      id: 'p5',
      fundiId: 'f4',
      title: 'Post-construction cleanup',
      description: 'Deep clean after full apartment renovation.',
      imageUrl: 'https://picsum.photos/seed/clean1/600/600',
    ),
    const PortfolioItem(
      id: 'p6',
      fundiId: 'f9',
      title: 'Screen replacement',
      description: 'Original screen replacement for a flagship phone.',
      imageUrl: 'https://picsum.photos/seed/phone1/600/600',
    ),
  ];

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  static Fundi? fundiById(String id) {
    for (final fundi in fundis) {
      if (fundi.id == id) return fundi;
    }
    return null;
  }

  static ServiceCategory categoryById(String id) {
    return categories.firstWhere((c) => c.id == id);
  }

  static List<ServiceRequest> requestsForCustomer(String customerId) {
    return requests.where((r) => r.customerId == customerId).toList();
  }

  static List<ServiceRequest> requestsForFundi(String fundiId) {
    return requests.where((r) => r.fundiId == fundiId).toList();
  }

  static List<Review> reviewsForFundi(String fundiId) {
    return reviews.where((r) => r.fundiId == fundiId).toList();
  }

  static List<PortfolioItem> portfolioForFundi(String fundiId) {
    return portfolioItems.where((p) => p.fundiId == fundiId).toList();
  }

  static Availability availabilityForFundi(String fundiId) {
    return availabilities.firstWhere(
      (a) => a.fundiId == fundiId,
      orElse: () => Availability(
        fundiId: fundiId,
        isAvailable: true,
        workingDays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
        startTime: '08:00',
        endTime: '17:00',
      ),
    );
  }
}