// Gamified Syllabus Tracker — Interactive Mobile Web Preview
// GLS University - BCA Semester V

const appState = {
  user: {
    name: 'Vaja Mital',
    email: 'mital.vaja@glsuniversity.ac.in',
    class: 'BCA Sem V (Div B)',
    role: 'student',
    totalXp: 340,
    currentLevel: 3,
    streak: 7,
    longestStreak: 12,
  },
  levelTiers: [
    { level: 1, name: 'Beginner', minXp: 0, maxXp: 100, icon: '🌱' },
    { level: 2, name: 'Learner', minXp: 100, maxXp: 250, icon: '📚' },
    { level: 3, name: 'Explorer', minXp: 250, maxXp: 500, icon: '🚀' },
    { level: 4, name: 'Achiever', minXp: 500, maxXp: 900, icon: '⭐' },
    { level: 5, name: 'Scholar', minXp: 900, maxXp: 1500, icon: '🎓' },
    { level: 6, name: 'Pro', minXp: 1500, maxXp: 99999, icon: '👑' },
  ],
  subjects: [
    {
      id: 1,
      name: 'Mathematics',
      code: 'MAT-501',
      color: '#4f46e5',
      chapters: [
        {
          id: 101,
          name: 'Unit 1: Linear Algebra',
          topics: [
            { id: 1001, name: 'Matrix Operations & Inverses', priority: 'high', completed: true },
            { id: 1002, name: 'Eigenvalues & Diagonalization', priority: 'high', completed: true },
            { id: 1003, name: 'Vector Spaces & Subspaces', priority: 'medium', completed: false },
          ]
        },
        {
          id: 102,
          name: 'Unit 2: Differential Calculus',
          topics: [
            { id: 1004, name: 'Multivariable Limits & Continuity', priority: 'medium', completed: true },
            { id: 1005, name: 'Lagrange Multipliers', priority: 'high', completed: false },
          ]
        }
      ]
    },
    {
      id: 2,
      name: 'Computer Science',
      code: 'CSC-502',
      color: '#0ea5e9',
      chapters: [
        {
          id: 201,
          name: 'Unit 1: Trees & Balanced BSTs',
          topics: [
            { id: 2001, name: 'BST Traversals (Inorder/Pre/Post)', priority: 'high', completed: true },
            { id: 2002, name: 'AVL Tree Rotations', priority: 'high', completed: true },
            { id: 2003, name: 'Min/Max Binary Heaps', priority: 'medium', completed: false },
          ]
        }
      ]
    },
    {
      id: 3,
      name: 'Database Management',
      code: 'DBMS-503',
      color: '#10b981',
      chapters: [
        {
          id: 301,
          name: 'Unit 1: Relational Schema & SQL',
          topics: [
            { id: 3001, name: 'Advanced SQL Joins & Subqueries', priority: 'high', completed: true },
            { id: 3002, name: 'Database Normalization (1NF to BCNF)', priority: 'high', completed: false },
          ]
        }
      ]
    },
    {
      id: 4,
      name: 'Web & Mobile App Dev',
      code: 'MAD-504',
      color: '#8b5cf6',
      chapters: [
        {
          id: 401,
          name: 'Unit 1: Flutter Architecture',
          topics: [
            { id: 4001, name: 'Widget Lifecycle & BuildContext', priority: 'high', completed: true },
            { id: 4002, name: 'Provider State Management', priority: 'high', completed: false },
          ]
        }
      ]
    }
  ],
  tasks: [
    { id: 1, subject: 'Database Management', topic: 'Database Normalization (1NF to BCNF)', time: '10:00 AM', priority: 'high', completed: false },
    { id: 2, subject: 'Computer Science', topic: 'Min/Max Binary Heaps', time: '02:30 PM', priority: 'medium', completed: false },
    { id: 3, subject: 'Web & Mobile App Dev', topic: 'Provider State Management', time: '05:00 PM', priority: 'high', completed: false },
    { id: 4, subject: 'Mathematics', topic: 'Eigenvalues & Diagonalization', time: '11:00 AM', priority: 'high', completed: true },
  ],
  badges: [
    { id: 1, name: 'First Step', desc: 'Complete your first topic', icon: '🚀', unlocked: true },
    { id: 2, name: '3-Day Streak', desc: 'Study for 3 consecutive days', icon: '⚡', unlocked: true },
    { id: 3, name: '7-Day Streak', desc: 'Maintain a 7-day study streak', icon: '🔥', unlocked: true },
    { id: 4, name: 'Perfect Score', desc: 'Score 100% on any chapter quiz', icon: '🎯', unlocked: true },
    { id: 5, name: 'Math Master', desc: 'Complete all Mathematics topics', icon: '📐', unlocked: false },
    { id: 6, name: 'Quiz Champion', desc: 'Complete 10 quizzes successfully', icon: '🏆', unlocked: false },
  ],
  quizzes: [
    {
      id: 1,
      title: 'Matrix & Eigenvalues Mastery Quiz',
      subject: 'Mathematics',
      chapter: 'Unit 1: Linear Algebra',
      xpReward: 20,
      questions: [
        {
          q: 'What is the determinant of an identity matrix I of size 3x3?',
          opts: ['0', '1', '3', 'Undefined'],
          correct: 1,
          exp: 'The determinant of an identity matrix is always 1.'
        },
        {
          q: 'If λ is an eigenvalue of matrix A, then (A - λI) must be:',
          opts: ['Orthogonal', 'Invertible', 'Singular (Det = 0)', 'Symmetric'],
          correct: 2,
          exp: 'By characteristic equation det(A - λI) = 0, the matrix is singular.'
        }
      ]
    },
    {
      id: 2,
      title: 'AVL Trees & BST Operations Quiz',
      subject: 'Computer Science',
      chapter: 'Unit 1: Trees & Balanced BSTs',
      xpReward: 25,
      questions: [
        {
          q: 'What is the allowed balance factor in an AVL tree?',
          opts: ['-1, 0, +1', 'Only 0', '-2, 0, +2', 'Any positive integer'],
          correct: 0,
          exp: 'AVL trees strictly allow balance factors of -1, 0, or +1.'
        }
      ]
    }
  ],
  leaderboard: [
    { rank: 1, name: 'Shaikh Yusrabanu', xp: 620, lvl: 4, badges: 5 },
    { rank: 2, name: 'Kagdi Rehan', xp: 490, lvl: 3, badges: 4 },
    { rank: 3, name: 'Vaja Mital (You)', xp: 340, lvl: 3, badges: 4 },
    { rank: 4, name: 'Patel Aarav', xp: 280, lvl: 3, badges: 2 },
  ],
  notifications: [
    { title: "You're on fire! 🔥", msg: 'You achieved a 7-day study streak! +15 XP awarded.', type: 'streak' },
    { title: 'Upcoming Deadline Alert ⏰', msg: 'Database Normalization topic target date is tomorrow.', type: 'reminder' },
    { title: 'Perfect Score Badge Unlocked! 🎯', msg: 'You scored 100% on the Linear Algebra Quiz.', type: 'badge' },
  ],
  currentScreen: 'home',
};

// Utilities
function calculateLevel(xp) {
  for (let tier of appState.levelTiers) {
    if (xp >= tier.minXp && (tier.level === 6 || xp < tier.maxXp)) {
      const range = tier.maxXp - tier.minXp;
      const progress = tier.level === 6 ? 1 : (xp - tier.minXp) / range;
      return { ...tier, progress: Math.min(1, Math.max(0, progress)), xpToNext: tier.maxXp - xp };
    }
  }
  return { ...appState.levelTiers[0], progress: 0, xpToNext: 100 };
}

function getAllTopics() {
  const list = [];
  appState.subjects.forEach(s => s.chapters.forEach(c => c.topics.forEach(t => list.push({ ...t, subject: s.name, color: s.color }))));
  return list;
}

// Navigation
function showScreen(name) {
  appState.currentScreen = name;
  document.querySelectorAll('.nav-item').forEach(btn => {
    btn.classList.remove('active');
    if (btn.innerText.toLowerCase().includes(name)) btn.classList.add('active');
  });

  const main = document.getElementById('mainContent');
  if (name === 'home') renderHomeScreen(main);
  else if (name === 'syllabus') renderSyllabusScreen(main);
  else if (name === 'planner') renderPlannerScreen(main);
  else if (name === 'quizzes') renderQuizzesScreen(main);
  else if (name === 'profile') renderProfileScreen(main);
  else if (name === 'leaderboard') renderLeaderboardScreen(main);
  else if (name === 'reports') renderReportsScreen(main);
  else if (name === 'admin') renderAdminScreen(main);
}

// Render Home Screen
function renderHomeScreen(container) {
  const lvl = calculateLevel(appState.user.totalXp);
  const allTopics = getAllTopics();
  const completedTopics = allTopics.filter(t => t.completed).length;
  const overallPercent = Math.round((completedTopics / allTopics.length) * 100);

  container.innerHTML = `
    <!-- Level Banner -->
    <div class="level-banner" onclick="showScreen('leaderboard')">
      <div class="level-row">
        <div class="level-avatar">${lvl.icon}</div>
        <div class="level-details">
          <div class="level-name-xp">
            <span class="level-name">Level ${lvl.level} — ${lvl.name}</span>
            <span class="xp-badge">⚡ ${appState.user.totalXp} XP</span>
          </div>
          <div style="font-size: 11px; opacity: 0.9; margin-top: 2px;">
            ${lvl.level === 6 ? 'Maximum rank reached! 👑' : `${lvl.xpToNext} XP needed for Level ${lvl.level + 1}`}
          </div>
        </div>
      </div>
      <div class="level-progress-bar">
        <div class="level-progress-fill" style="width: ${lvl.progress * 100}%"></div>
      </div>
    </div>

    <!-- 2x2 Stats Grid -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon-wrap" style="background: var(--primary-light); color: var(--primary);">📋</div>
        <div>
          <div class="stat-val">${appState.tasks.filter(t => t.completed).length}/${appState.tasks.length}</div>
          <div class="stat-lbl">Today's Tasks</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon-wrap" style="background: var(--success-light); color: var(--success);">✅</div>
        <div>
          <div class="stat-val">${completedTopics}/${allTopics.length}</div>
          <div class="stat-lbl">Topics Done</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon-wrap" style="background: var(--streak-flame-light); color: var(--streak-flame);">🔥</div>
        <div>
          <div class="stat-val">${appState.user.streak} Days</div>
          <div class="stat-lbl">Streak 🔥</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon-wrap" style="background: var(--xp-gold-light); color: var(--xp-gold);">⭐</div>
        <div>
          <div class="stat-val">${appState.user.totalXp} XP</div>
          <div class="stat-lbl">Total Points</div>
        </div>
      </div>
    </div>

    <!-- Overall Syllabus Progress -->
    <div class="card" onclick="showScreen('syllabus')" style="cursor:pointer;">
      <div style="display:flex; align-items:center; gap: 14px;">
        <div style="font-size: 28px; font-weight:800; color: var(--primary);">${overallPercent}%</div>
        <div style="flex:1;">
          <div style="font-weight:700; font-size: 14px;">Overall Syllabus Progress</div>
          <div style="font-size: 12px; color: var(--text-muted);">${completedTopics} of ${allTopics.length} topics finished across 4 subjects.</div>
          <div style="height: 6px; background: var(--surface-alt); border-radius: 4px; margin-top: 6px; overflow: hidden;">
            <div style="height:100%; width: ${overallPercent}%; background: var(--primary);"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Today's Study Goals -->
    <div class="section-title">
      <span>Today's Study Goals 🎯</span>
      <button class="link-btn" onclick="showScreen('planner')">Planner</button>
    </div>

    <div id="todayTaskList">
      ${appState.tasks.map(t => `
        <div class="task-item ${t.completed ? 'completed' : ''}">
          <div class="checkbox-round ${t.completed ? 'checked' : ''}" onclick="toggleTask(${t.id})">
            ${t.completed ? '✓' : ''}
          </div>
          <div class="task-content">
            <div class="task-title">${t.topic}</div>
            <div class="task-sub">${t.subject} • ${t.time}</div>
          </div>
          <span class="chip-priority chip-${t.priority}">${t.priority.toUpperCase()}</span>
        </div>
      `).join('')}
    </div>
  `;
}

// Toggle Task and add XP
function toggleTask(id) {
  const t = appState.tasks.find(x => x.id === id);
  if (!t) return;
  t.completed = !t.completed;
  if (t.completed) {
    const earned = t.priority === 'high' ? 20 : 10;
    appState.user.totalXp += earned;
    checkLevelUp();
  }
  showScreen(appState.currentScreen);
}

function checkLevelUp() {
  const lvl = calculateLevel(appState.user.totalXp);
  if (lvl.level > appState.user.currentLevel) {
    appState.user.currentLevel = lvl.level;
    document.getElementById('lvlUpIcon').innerText = lvl.icon;
    document.getElementById('lvlUpTitle').innerText = `Level ${lvl.level} — ${lvl.name}`;
    document.getElementById('levelUpModal').classList.add('active');
  }
}

function closeLevelUp() {
  document.getElementById('levelUpModal').classList.remove('active');
}

// Render Syllabus Screen
function renderSyllabusScreen(container) {
  container.innerHTML = `
    <div class="section-title">
      <span>Academic Syllabus Tree 📚</span>
      <span style="font-size: 12px; color: var(--text-muted);">GLS BCA Sem V</span>
    </div>
    ${appState.subjects.map(s => {
      const allSubTopics = [];
      s.chapters.forEach(c => c.topics.forEach(t => allSubTopics.push(t)));
      const done = allSubTopics.filter(t => t.completed).length;
      const pct = Math.round((done / allSubTopics.length) * 100) || 0;

      return `
        <div class="card" style="border-left: 4px solid ${s.color};">
          <div style="display:flex; justify-content:space-between; align-items:center;">
            <div>
              <div style="font-weight:700; font-size:15px;">${s.name}</div>
              <div style="font-size:11px; color:var(--text-muted);">${s.code} • ${s.chapters.length} Units</div>
            </div>
            <span class="xp-badge" style="background: ${s.color};">${pct}%</span>
          </div>
          <div style="margin-top: 10px;">
            ${s.chapters.map(c => `
              <div style="margin-top: 8px; font-size: 13px; font-weight: 600; color: var(--text-main);">
                📑 ${c.name}
              </div>
              <div style="margin-left: 10px; margin-top: 4px;">
                ${c.topics.map(tp => `
                  <div style="display:flex; align-items:center; gap: 8px; font-size: 12px; padding: 4px 0;">
                    <input type="checkbox" ${tp.completed ? 'checked' : ''} onchange="toggleTopic(${tp.id})">
                    <span style="${tp.completed ? 'text-decoration:line-through; color:var(--text-muted);' : ''}">${tp.name}</span>
                    <span class="chip-priority chip-${tp.priority}" style="margin-left:auto; font-size:9px;">${tp.priority.toUpperCase()}</span>
                  </div>
                `).join('')}
              </div>
            `).join('')}
          </div>
        </div>
      `;
    }).join('')}
  `;
}

function toggleTopic(id) {
  appState.subjects.forEach(s => {
    s.chapters.forEach(c => {
      const t = c.topics.find(x => x.id === id);
      if (t) {
        t.completed = !t.completed;
        if (t.completed) {
          appState.user.totalXp += t.priority === 'high' ? 20 : 10;
          checkLevelUp();
        }
      }
    });
  });
  showScreen(appState.currentScreen);
}

// Render Planner Screen
function renderPlannerScreen(container) {
  container.innerHTML = `
    <div class="section-title">
      <span>Daily & Weekly Planner 📅</span>
      <button class="link-btn" onclick="addCustomTaskPrompt()">+ Add Task</button>
    </div>
    <div class="card" style="background: var(--primary-light); border-color: var(--primary);">
      <div style="font-weight:700; color: var(--primary); font-size: 13px;">💡 Smart Task Suggestions</div>
      <p style="font-size: 12px; color: var(--text-main); margin-top: 4px;">Prioritize: 1) Overdue topics, 2) Approaching deadlines, 3) High priority</p>
      <button class="btn-primary" style="margin-top: 8px; padding: 8px; font-size: 12px;" onclick="scheduleUrgent()">+ Auto-Schedule Database Normalization</button>
    </div>
    <div style="margin-top: 14px;">
      ${appState.tasks.map(t => `
        <div class="task-item ${t.completed ? 'completed' : ''}">
          <div class="checkbox-round ${t.completed ? 'checked' : ''}" onclick="toggleTask(${t.id})">
            ${t.completed ? '✓' : ''}
          </div>
          <div class="task-content">
            <div class="task-title">${t.topic}</div>
            <div class="task-sub">${t.subject} • ${t.time}</div>
          </div>
          <span class="chip-priority chip-${t.priority}">${t.priority.toUpperCase()}</span>
        </div>
      `).join('')}
    </div>
  `;
}

function scheduleUrgent() {
  appState.tasks.push({
    id: Date.now(),
    subject: 'Database Management',
    topic: 'Database Normalization (1NF to BCNF)',
    time: '06:00 PM',
    priority: 'high',
    completed: false
  });
  showScreen('planner');
}

function addCustomTaskPrompt() {
  const name = prompt('Enter study task name:');
  if (name) {
    appState.tasks.push({
      id: Date.now(),
      subject: 'Core Subject',
      topic: name,
      time: '07:00 PM',
      priority: 'medium',
      completed: false
    });
    showScreen('planner');
  }
}

// Render Quizzes Screen
function renderQuizzesScreen(container) {
  container.innerHTML = `
    <div class="section-title">
      <span>Chapter-wise Quizzes 🧠</span>
      <span class="xp-badge">+15-25 XP</span>
    </div>
    ${appState.quizzes.map(q => `
      <div class="card">
        <div style="font-weight:700; font-size: 15px;">${q.title}</div>
        <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">${q.subject} • ${q.chapter}</div>
        <div style="margin-top: 10px; font-size: 12px; color: var(--text-muted);">${q.questions.length} MCQ Questions</div>
        <button class="btn-primary" style="margin-top: 12px; padding: 10px;" onclick="playQuiz(${q.id})">Start Quiz 🚀</button>
      </div>
    `).join('')}
  `;
}

function playQuiz(id) {
  const qz = appState.quizzes.find(x => x.id === id);
  if (!qz) return;
  const q = qz.questions[0];

  const ans = prompt(`${qz.title}\n\nQ: ${q.q}\n\n1) ${q.opts[0]}\n2) ${q.opts[1]}\n3) ${q.opts[2]}\n4) ${q.opts[3]}\n\nEnter (1-4):`);
  if (ans == (q.correct + 1)) {
    appState.user.totalXp += qz.xpReward;
    checkLevelUp();
    alert(`🎉 Correct Answer!\n\n+${qz.xpReward} XP earned! Good job.`);
  } else if (ans) {
    alert(`❌ Incorrect Answer.\n\nExplanation: ${q.exp}`);
  }
  showScreen('quizzes');
}

// Render Profile Screen
function renderProfileScreen(container) {
  const lvl = calculateLevel(appState.user.totalXp);
  container.innerHTML = `
    <div class="card text-center" style="text-align: center;">
      <div style="font-size: 54px;">👨‍🎓</div>
      <h2 style="font-size: 18px; margin-top: 6px;">${appState.user.name}</h2>
      <p style="font-size: 12px; color: var(--text-muted);">${appState.user.email}</p>
      <div style="margin-top: 8px; font-size: 12px; background: var(--surface-alt); padding: 4px 10px; border-radius: 8px; display: inline-block;">
        ${appState.user.class} • GLS University
      </div>
    </div>
    <div class="level-banner" style="margin-top: 14px;">
      <div class="level-row">
        <div class="level-avatar">${lvl.icon}</div>
        <div class="level-details">
          <div class="level-name">Level ${lvl.level} — ${lvl.name}</div>
          <div style="font-size: 12px;">Total XP: ${appState.user.totalXp} XP</div>
        </div>
      </div>
    </div>
    <div class="card" style="margin-top: 14px;">
      <div style="font-weight:700; font-size:14px; margin-bottom: 8px;">Switch Role Mode</div>
      <button class="btn-primary" style="background: var(--surface-alt); color: var(--text-main); border: 1px solid var(--border);" onclick="showScreen('admin')">🏛️ Switch to Faculty & Admin Portal</button>
    </div>
  `;
}

// Render Leaderboard Screen
function renderLeaderboardScreen(container) {
  container.innerHTML = `
    <div class="section-title">
      <span>Class Leaderboard 🏆</span>
      <button class="link-btn" onclick="showScreen('home')">Back</button>
    </div>
    <div class="card" style="background: linear-gradient(135deg, #1e293b, #334155); color:white; text-align:center;">
      <div style="font-size: 32px;">👑</div>
      <div style="font-weight:800; font-size: 16px;">BCA Semester V Rankings</div>
      <p style="font-size: 11px; opacity:0.8;">GLS University Academic Leaderboard</p>
    </div>
    ${appState.leaderboard.map(item => `
      <div class="card" style="display:flex; justify-content:space-between; align-items:center;">
        <div style="display:flex; align-items:center; gap: 12px;">
          <span style="font-size: 18px; font-weight:800;">${item.rank === 1 ? '🥇' : item.rank === 2 ? '🥈' : item.rank === 3 ? '🥉' : '#' + item.rank}</span>
          <div>
            <div style="font-weight:700; font-size: 14px;">${item.name}</div>
            <div style="font-size: 11px; color: var(--text-muted);">Level ${item.lvl} • ${item.badges} Badges</div>
          </div>
        </div>
        <span class="xp-badge">⚡ ${item.xp} XP</span>
      </div>
    `).join('')}
  `;
}

// Render Reports Screen
function renderReportsScreen(container) {
  container.innerHTML = `
    <div class="section-title">
      <span>Academic Reports & Analytics 📊</span>
      <button class="link-btn" onclick="showScreen('home')">Back</button>
    </div>
    <div class="card">
      <div style="font-weight:700;">Weekly Study Velocity</div>
      <div style="display:flex; justify-content:space-around; align-items:flex-end; height: 100px; margin-top: 14px;">
        <div style="text-align:center;"><div style="height: 40px; width: 20px; background: var(--primary); border-radius:4px;"></div><span style="font-size:10px;">Mon</span></div>
        <div style="text-align:center;"><div style="height: 20px; width: 20px; background: var(--primary); border-radius:4px;"></div><span style="font-size:10px;">Tue</span></div>
        <div style="text-align:center;"><div style="height: 65px; width: 20px; background: var(--primary); border-radius:4px;"></div><span style="font-size:10px;">Wed</span></div>
        <div style="text-align:center;"><div style="height: 50px; width: 20px; background: var(--primary); border-radius:4px;"></div><span style="font-size:10px;">Thu</span></div>
        <div style="text-align:center;"><div style="height: 85px; width: 20px; background: var(--primary); border-radius:4px;"></div><span style="font-size:10px;">Fri</span></div>
        <div style="text-align:center;"><div style="height: 60px; width: 20px; background: var(--primary); border-radius:4px;"></div><span style="font-size:10px;">Sat</span></div>
        <div style="text-align:center;"><div style="height: 35px; width: 20px; background: var(--primary); border-radius:4px;"></div><span style="font-size:10px;">Sun</span></div>
      </div>
    </div>
    <button class="btn-primary" onclick="alert('Exporting official academic PDF report for GLS University...')">📄 Export Official PDF Report</button>
  `;
}

// Render Admin Screen
function renderAdminScreen(container) {
  container.innerHTML = `
    <div class="section-title">
      <span>Faculty & Admin Portal 🏛️</span>
      <button class="link-btn" onclick="showScreen('home')">Student Mode</button>
    </div>
    <div class="card" style="background:#1e293b; color:white;">
      <div style="font-weight:700; font-size:15px;">GLS University — BCA Dept Admin</div>
      <div style="font-size:12px; opacity:0.8;">Curriculum Oversight & Student Progress Monitoring</div>
    </div>
    <div class="stats-grid">
      <div class="stat-card"><div class="stat-val">3</div><div class="stat-lbl">Enrolled Students</div></div>
      <div class="stat-card"><div class="stat-val">4</div><div class="stat-lbl">Active Subjects</div></div>
      <div class="stat-card"><div class="stat-val">68%</div><div class="stat-lbl">Avg Completion</div></div>
      <div class="stat-card"><div class="stat-val">48</div><div class="stat-lbl">Quizzes Taken</div></div>
    </div>
    <div class="card">
      <div style="font-weight:700;">Student Roster</div>
      <div style="margin-top: 8px; font-size: 13px;">
        <div>👤 Vaja Mital (BCA Div B) — 340 XP • 7d Streak</div>
        <div style="margin-top: 4px;">👤 Kagdi Rehan (BCA Div A) — 490 XP • 5d Streak</div>
        <div style="margin-top: 4px;">👤 Shaikh Yusrabanu (BCA Div B) — 620 XP • 9d Streak</div>
      </div>
    </div>
  `;
}

// Notifications toggle
function toggleNotifs() {
  const modal = document.getElementById('notifModal');
  modal.classList.toggle('active');
  if (modal.classList.contains('active')) {
    const list = document.getElementById('notifList');
    list.innerHTML = appState.notifications.map(n => `
      <div style="padding: 10px; border-bottom: 1px solid var(--border);">
        <div style="font-weight:700; font-size: 13px;">${n.title}</div>
        <div style="font-size: 12px; color: var(--text-muted);">${n.msg}</div>
      </div>
    `).join('');
  }
}

// Initialize
window.addEventListener('DOMContentLoaded', () => {
  showScreen('home');
});
