from abc import ABC, abstractmethod
from collections import defaultdict
import random
from typing import List, Dict, DefaultDict
import numpy as np

from gym.spaces import Space
from gym.spaces.utils import flatdim


class MultiAgent(ABC):
    """Base class for multi-agent reinforcement learning

    **DO NOT CHANGE THIS BASE CLASS**

    """

    def __init__(
        self,
        num_agents: int,
        action_spaces: List[Space],
        gamma: float,
        **kwargs
    ):
        """Constructor of base agent for Q-Learning

        Initializes basic variables of MARL agents
        namely epsilon, learning rate and discount rate.

        :param num_agents (int): number of agents
        :param action_spaces (List[Space]): action spaces of the environment for each agent
        :param gamma (float): discount factor (gamma)

        :attr n_acts (List[int]): number of actions for each agent
        """

        self.num_agents = num_agents
        self.action_spaces = action_spaces
        self.n_acts = [flatdim(action_space) for action_space in action_spaces]

        self.gamma: float = gamma

    @abstractmethod
    def act(self) -> List[int]:
        """Chooses an action for all agents for stateless task

        :return (List[int]): index of selected action for each agent
        """
        ...

    @abstractmethod
    def schedule_hyperparameters(self, timestep: int, max_timestep: int):
        """Updates the hyperparameters

        This function is called before every episode and allows you to schedule your
        hyperparameters.

        :param timestep (int): current timestep at the beginning of the episode
        :param max_timestep (int): maximum timesteps that the training loop will run for
        """
        ...

    @abstractmethod
    def learn(self):
        ...


class IndependentQLearningAgents(MultiAgent):
    """Agent using the Independent Q-Learning algorithm

    **YOU NEED TO IMPLEMENT FUNCTIONS IN THIS CLASS**
    """

    def __init__(self, learning_rate: float =0.5, epsilon: float =1.0, **kwargs):
        """Constructor of IndependentQLearningAgents

        :param learning_rate (float): learning rate for Q-learning updates
        :param epsilon (float): epsilon value for all agents

        :attr q_tables (List[DefaultDict]): tables for Q-values mapping actions ACTs
            to respective Q-values for all agents

        Initializes some variables of the Independent Q-Learning agents, namely the epsilon, discount rate
        and learning rate
        """

        super().__init__(**kwargs)
        self.learning_rate = learning_rate
        self.epsilon = epsilon

        # initialise Q-tables for all agents
        self.q_tables: List[DefaultDict] = [defaultdict(lambda: 0) for i in range(self.num_agents)]

    def act(self) -> List[int]:
        """Implement the epsilon-greedy action selection here for stateless task

        **YOU MUST IMPLEMENT THIS FUNCTION FOR Q5**

        :return (List[int]): index of selected action for each agent
        """
        ### PUT YOUR CODE HERE ###
        #print("act")
        actions = []
        for i in range(self.num_agents):
            if self.epsilon < np.random.uniform(0,1):
                q_actions = [self.q_tables[i][a] for a in range(self.n_acts[i])]
                actions.append(np.argmax(q_actions))
            else:
                actions.append(self.action_spaces[i].sample())
        #raise NotImplementedError("Needed for Q5")
        #print(actions)
        return actions

    def learn(
        self, actions: List[int], rewards: List[float], dones: List[bool]
    ) -> List[float]:
        """Updates the Q-tables based on agents' experience

        **YOU MUST IMPLEMENT THIS FUNCTION FOR Q5**

        :param action (List[int]): index of applied action of each agent
        :param rewards (List[float]): received reward for each agent
        :param dones (List[bool]): flag indicating whether a terminal state has been reached for each agent
        :return (List[float]): updated Q-values for current actions of each agent
        """
        #print("learn")
        updated_values = []
        ### PUT YOUR CODE HERE ###
        #print(rewards)
        for i in range(self.num_agents):
            q_actions = [self.q_tables[i][a] for a in range(self.n_acts[i])]
            #print(i, q_actions)
            updated_values.append(q_actions[actions[i]] + self.learning_rate * (rewards[i] + self.gamma * (1 - dones[i]) * np.max(q_actions) - q_actions[actions[i]]))
            self.q_tables[i][actions[i]] = updated_values[i]
            #print("---")
            #print(i, "q_actions",q_actions, "actions[i]",actions[i],"rewards[i]",rewards[i],"q_tables[i]",self.q_tables[i])
        # raise NotImplementedError("Needed for Q5")
        return updated_values

    def schedule_hyperparameters(self, timestep: int, max_timestep: int):
        """Updates the hyperparameters

        **YOU MUST IMPLEMENT THIS FUNCTION FOR Q5**

        This function is called before every episode and allows you to schedule your
        hyperparameters.

        :param timestep (int): current timestep at the beginning of the episode
        :param max_timestep (int): maximum timesteps that the training loop will run for
        """
        ### PUT YOUR CODE HERE ###
        self.epsilon = self.epsilon * (max_timestep-timestep) / (max_timestep-timestep+1)
        #print("schedule",self.epsilon)
        # raise NotImplementedError("Needed for Q5")


class JointActionLearning(MultiAgent):
    """
    Agents using the Joint Action Learning algorithm with Opponent Modelling

    **YOU NEED TO IMPLEMENT FUNCTIONS IN THIS CLASS**
    """

    def __init__(self, learning_rate: float =0.5, epsilon: float =1.0, **kwargs):
        """Constructor of JointActionLearning

        :param learning_rate (float): learning rate for Q-learning updates
        :param epsilon (float): epsilon value for all agents

        :attr q_tables (List[DefaultDict]): tables for Q-values mapping joint actions ACTs
            to respective Q-values for all agents
        :attr models (List[DefaultDict]): each agent holding model of other agent
            mapping other agent actions to their counts

        Initializes some variables of the Joint Action Learning agents, namely the epsilon, discount rate and learning rate
        """

        super().__init__(**kwargs)
        self.learning_rate = learning_rate
        self.epsilon = epsilon
        self.n_acts = [flatdim(action_space) for action_space in self.action_spaces]

        # initialise Q-tables for all agents
        self.q_tables: List[DefaultDict] = [defaultdict(lambda: 0) for _ in range(self.num_agents)]

        # initialise models for each agent mapping state to other agent actions to count of other agent action
        # in state
        self.models = [defaultdict(lambda: 0) for _ in range(self.num_agents)] 

    def act(self) -> List[int]:
        """Implement the epsilon-greedy action selection here for stateless task

        **YOU MUST IMPLEMENT THIS FUNCTION FOR Q5**

        :return (List[int]): index of selected action for each agent
        """
        ### PUT YOUR CODE HERE ###
        joint_action = []
        for i in range(self.num_agents):
            if self.epsilon < np.random.uniform(0,1):
                denominator = 0.0
                EV = np.zeros(self.n_acts[i])
                for j in range(self.n_acts[i]):
                    for k in range(self.n_acts[1-i]):
                        denominator = denominator + self.models[i][k]
                        EV[j] = EV[j] + self.models[i][k] * self.q_tables[i][(j,k)]
                EV = EV / np.max([1, denominator])
                joint_action.append(np.argmax(EV))
            else:
                joint_action.append(self.action_spaces[i].sample())
        # raise NotImplementedError("Needed for Q5")
        return joint_action

    def learn(
        self, actions: List[int], rewards: List[float], dones: List[bool]
    ) -> List[float]:
        """Updates the Q-tables and models based on agents' experience

        **YOU MUST IMPLEMENT THIS FUNCTION FOR Q5**

        :param action (List[int]): index of applied action of each agent
        :param rewards (List[float]): received reward for each agent
        :param dones (List[bool]): flag indicating whether a terminal state has been reached for each agent
        :return (List[float]): updated Q-values for current observation-action pair of each agent
        """
        ### PUT YOUR CODE HERE ###
        updated_values = []
        for i in range(self.num_agents):
            self.models[i][actions[1-i]] = self.models[i][actions[1-i]] + 1
            denominator = 0.0
            EV = np.zeros(self.n_acts[i])
            for j in range(self.n_acts[i]):
                for k in range(self.n_acts[1-i]):
                    denominator = denominator + self.models[i][k]
                    EV[j] = EV[j] + self.models[i][k] * self.q_tables[i][(j,k)]
            EV = EV / np.max([1, denominator])
            updated_values.append(self.q_tables[i][(actions[i],actions[1-i])] + self.learning_rate * (rewards[i] + self.gamma * (1 - dones[i]) * np.max(EV) - self.q_tables[i][(actions[i],actions[1-i])]))
            self.q_tables[i][(actions[i],actions[1-i])] = updated_values[i]
        # raise NotImplementedError("Needed for Q5")
        return updated_values

    def schedule_hyperparameters(self, timestep: int, max_timestep: int):
        """Updates the hyperparameters

        **YOU MUST IMPLEMENT THIS FUNCTION FOR Q5**

        This function is called before every episode and allows you to schedule your
        hyperparameters.

        :param timestep (int): current timestep at the beginning of the episode
        :param max_timestep (int): maximum timesteps that the training loop will run for
        """
        ### PUT YOUR CODE HERE ###
        self.epsilon = self.epsilon * (max_timestep-timestep) / (max_timestep-timestep+1)
        # raise NotImplementedError("Needed for Q5")
