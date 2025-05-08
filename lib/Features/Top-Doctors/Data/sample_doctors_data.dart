import 'package:careplus/Features/Top-Doctors/Data/Model/doctor_model.dart';

// Sample data for testing the doctor model and UI
final List<DoctorModel> sampleDoctors = [
  DoctorModel(
    id: '1',
    name: 'Dr. Rodger Struck',
    imageUrl: DoctorModel.defaultImageUrl,
    rating: 4.8,
    location: 'London, England',
    speciality: 'Heart Surgeon',
    isOnline: true,
    numOfPatients: 1500,
    about:
        'Dr. Rodger Struck is a highly skilled Heart Surgeon with over 15 years of experience. He specializes in minimally invasive cardiac procedures and has performed over 1000 successful surgeries.',
    numOfExperience: 15,
    numOfReview: 458,
    daySchedules: [
      DaySchedule(
        day: 'Mon',
        availableHours: [
          TimeSlot(
            id: '1-1',
            startTime: '09:00 AM',
            endTime: '10:00 AM',
            isBooked: false,
          ),
          TimeSlot(
            id: '1-2',
            startTime: '10:30 AM',
            endTime: '11:30 AM',
            isBooked: true,
          ),
          TimeSlot(
            id: '1-3',
            startTime: '01:00 PM',
            endTime: '02:00 PM',
            isBooked: false,
          ),
          TimeSlot(
            id: '1-4',
            startTime: '03:30 PM',
            endTime: '04:30 PM',
            isBooked: false,
          ),
        ],
      ),
      DaySchedule(
        day: 'Tue',
        availableHours: [
          TimeSlot(
            id: '2-1',
            startTime: '09:00 AM',
            endTime: '10:00 AM',
            isBooked: true,
          ),
          TimeSlot(
            id: '2-2',
            startTime: '11:00 AM',
            endTime: '12:00 PM',
            isBooked: false,
          ),
          TimeSlot(
            id: '2-3',
            startTime: '02:00 PM',
            endTime: '03:00 PM',
            isBooked: false,
          ),
        ],
      ),
      DaySchedule(
        day: 'Wen',
        availableHours: [
          TimeSlot(
            id: '3-1',
            startTime: '10:00 AM',
            endTime: '11:00 AM',
            isBooked: false,
          ),
          TimeSlot(
            id: '3-2',
            startTime: '01:00 PM',
            endTime: '02:00 PM',
            isBooked: false,
          ),
        ],
      ),
      DaySchedule(
        day: 'Tur',
        availableHours: [
          TimeSlot(
            id: '4-1',
            startTime: '09:00 AM',
            endTime: '10:00 AM',
            isBooked: false,
          ),
          TimeSlot(
            id: '4-2',
            startTime: '11:00 AM',
            endTime: '12:00 PM',
            isBooked: false,
          ),
          TimeSlot(
            id: '4-3',
            startTime: '02:00 PM',
            endTime: '03:00 PM',
            isBooked: true,
          ),
        ],
      ),
      DaySchedule(
        day: 'Fri',
        availableHours: [
          TimeSlot(
            id: '5-1',
            startTime: '10:00 AM',
            endTime: '11:00 AM',
            isBooked: false,
          ),
          TimeSlot(
            id: '5-2',
            startTime: '01:00 PM',
            endTime: '02:00 PM',
            isBooked: false,
          ),
          TimeSlot(
            id: '5-3',
            startTime: '03:00 PM',
            endTime: '04:00 PM',
            isBooked: false,
          ),
        ],
      ),
    ],
  ),
  DoctorModel(
    id: '2',
    name: 'Dr. Kathy Pacheco',
    imageUrl: DoctorModel.defaultImageUrl,
    rating: 4.7,
    location: 'New York, USA',
    speciality: 'Cardiologist',
    isOnline: false,
    numOfPatients: 1200,
    about:
        'Dr. Kathy Pacheco is a board-certified Cardiologist with expertise in preventive cardiology and heart disease management. She is known for her patient-centered approach and comprehensive care.',
    numOfExperience: 12,
    numOfReview: 320,
    daySchedules: [
      DaySchedule(
        day: 'Mon',
        availableHours: [
          TimeSlot(
            id: '6-1',
            startTime: '09:00 AM',
            endTime: '10:00 AM',
            isBooked: true,
          ),
          TimeSlot(
            id: '6-2',
            startTime: '11:00 AM',
            endTime: '12:00 PM',
            isBooked: false,
          ),
        ],
      ),
      DaySchedule(
        day: 'Wed',
        availableHours: [
          TimeSlot(
            id: '7-1',
            startTime: '02:00 PM',
            endTime: '03:00 PM',
            isBooked: false,
          ),
          TimeSlot(
            id: '7-2',
            startTime: '04:00 PM',
            endTime: '05:00 PM',
            isBooked: false,
          ),
        ],
      ),
      DaySchedule(
        day: 'Fri',
        availableHours: [
          TimeSlot(
            id: '8-1',
            startTime: '10:00 AM',
            endTime: '11:00 AM',
            isBooked: false,
          ),
          TimeSlot(
            id: '8-2',
            startTime: '01:00 PM',
            endTime: '02:00 PM',
            isBooked: true,
          ),
        ],
      ),
    ],
  ),
  DoctorModel(
    id: '3',
    name: 'Dr. Lorri Warf',
    imageUrl: DoctorModel.defaultImageUrl,
    rating: 4.9,
    location: 'Chicago, USA',
    speciality: 'General Dentist',
    isOnline: true,
    numOfPatients: 2000,
    about:
        'Dr. Lorri Warf is a General Dentist with a focus on cosmetic dentistry and preventive care. She is committed to providing comfortable and high-quality dental services to all her patients.',
    numOfExperience: 10,
    numOfReview: 520,
    daySchedules: [
      DaySchedule(
        day: 'Tue',
        availableHours: [
          TimeSlot(
            id: '9-1',
            startTime: '09:00 AM',
            endTime: '10:00 AM',
            isBooked: false,
          ),
          TimeSlot(
            id: '9-2',
            startTime: '11:00 AM',
            endTime: '12:00 PM',
            isBooked: false,
          ),
        ],
      ),
      DaySchedule(
        day: 'Tur',
        availableHours: [
          TimeSlot(
            id: '10-1',
            startTime: '02:00 PM',
            endTime: '03:00 PM',
            isBooked: false,
          ),
          TimeSlot(
            id: '10-2',
            startTime: '04:00 PM',
            endTime: '05:00 PM',
            isBooked: true,
          ),
        ],
      ),
    ],
  ),
];
