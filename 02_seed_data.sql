-- ============================================================
-- SEED DATA — Employees, leave records, HR policy docs
-- ============================================================

USE DATABASE HR_ASSISTANT_DB;
USE SCHEMA RAW;

-- Employees
INSERT INTO employees VALUES
(1,  'Rahul Sharma',   'Engineering',  'Senior Data Engineer',    95000, '2022-03-15', 'Bangalore', 'Excellent'),
(2,  'Priya Nair',     'Marketing',    'Growth Analyst',          72000, '2023-01-10', 'Mumbai',    'Good'),
(3,  'Arjun Mehta',    'Engineering',  'ML Engineer',             88000, '2021-07-20', 'Hyderabad', 'Excellent'),
(4,  'Sneha Patel',    'HR',           'HR Business Partner',     65000, '2022-11-05', 'Ahmedabad', 'Good'),
(5,  'Vikram Reddy',   'Finance',      'Financial Analyst',       78000, '2020-09-12', 'Chennai',   'Average'),
(6,  'Divya Kumar',    'Engineering',  'Backend Engineer',        82000, '2023-04-01', 'Bangalore', 'Good'),
(7,  'Amit Verma',     'Sales',        'Account Manager',         68000, '2021-02-28', 'Delhi',     'Excellent'),
(8,  'Neha Joshi',     'Marketing',    'Content Strategist',      61000, '2023-08-15', 'Pune',      'Good'),
(9,  'Rohan Gupta',    'Engineering',  'DevOps Engineer',         91000, '2020-05-10', 'Bangalore', 'Average'),
(10, 'Aisha Khan',     'Finance',      'Senior Accountant',       74000, '2022-06-22', 'Mumbai',    'Excellent');

-- Leave records
INSERT INTO leave_records VALUES
(1,  1, 'Annual',  '2026-01-05', '2026-01-10', 6,  TRUE),
(2,  2, 'Sick',    '2026-01-15', '2026-01-17', 3,  TRUE),
(3,  3, 'Casual',  '2026-02-01', '2026-02-02', 2,  TRUE),
(4,  4, 'Annual',  '2026-02-10', '2026-02-20', 11, TRUE),
(5,  5, 'Sick',    '2026-03-05', '2026-03-06', 2,  TRUE),
(6,  6, 'Casual',  '2026-03-12', '2026-03-13', 2,  FALSE),
(7,  7, 'Annual',  '2026-03-20', '2026-03-28', 9,  TRUE),
(8,  8, 'Sick',    '2026-04-02', '2026-04-04', 3,  TRUE),
(9,  9, 'Annual',  '2026-04-15', '2026-04-25', 11, TRUE),
(10, 10,'Casual',  '2026-04-28', '2026-04-29', 2,  TRUE);

-- HR policy documents (chunks for RAG)
INSERT INTO hr_policy_docs VALUES
(1,  'Leave Policy', 'Annual Leave',
 'All full-time employees are entitled to 18 days of annual leave per calendar year. Annual leave must be applied for at least 5 working days in advance. Unused annual leave can be carried forward up to a maximum of 9 days to the next calendar year. Annual leave encashment is allowed only at the time of resignation or retirement.'),

(2,  'Leave Policy', 'Sick Leave',
 'Employees are entitled to 12 days of sick leave per year. Sick leave of more than 2 consecutive days requires a medical certificate from a registered practitioner. Sick leave cannot be carried forward to the next year. Employees must inform their manager within 2 hours of their shift start time if they are taking sick leave.'),

(3,  'Leave Policy', 'Casual Leave',
 'Employees are entitled to 6 days of casual leave per year. Casual leave can be taken for personal emergencies or urgent matters. Maximum 3 consecutive casual leave days are allowed at a time. Casual leave cannot be combined with annual leave or public holidays without prior approval from HR.'),

(4,  'Performance Policy', 'Performance Review Cycle',
 'Performance reviews are conducted twice a year — in June and December. Employees rated Excellent receive a bonus of 20% of monthly salary. Employees rated Good receive 10% bonus. Employees rated Average receive no bonus but are eligible for a performance improvement plan. Employees rated Poor are placed on a mandatory 90-day PIP.'),

(5,  'Performance Policy', 'Promotion Criteria',
 'Employees must have a minimum of 18 months in their current role to be eligible for promotion. Two consecutive Excellent ratings are required for fast-track promotion. Promotions are approved by the department head and HR business partner jointly. Salary increments on promotion range from 15% to 30% based on the new role band.'),

(6,  'Remote Work Policy', 'Work From Home Guidelines',
 'Employees are eligible for up to 2 days of work from home per week after completing 6 months in the organisation. WFH requests must be submitted by Friday of the previous week. Employees must be reachable on all communication channels during WFH days. WFH is not permitted during the last week of any financial quarter.'),

(7,  'Compensation Policy', 'Salary Structure',
 'Salaries are reviewed annually in April. The average increment for the company is benchmarked at 8-12% based on company performance. Individual increments depend on performance rating, market benchmarking, and internal equity. All salary details are confidential and must not be disclosed to colleagues.'),

(8,  'Code of Conduct', 'Workplace Behaviour',
 'All employees must maintain professional conduct at all times. Harassment of any kind — verbal, physical, or digital — is strictly prohibited and will result in immediate disciplinary action. Employees must declare any conflict of interest to HR within 7 days of becoming aware. Violations of the code of conduct are investigated by the Ethics Committee.');
